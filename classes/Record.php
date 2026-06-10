<?php

include_once 'classes/IssuesDB.php';

class Record extends BaseTab {

  public function __construct() {
    parent::__construct();
  }

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $this->action = getOrDefault('action', 'display', ['display', 'downloadRecord', 'downloadFile', 'pdf']);

    $id = getOrDefault('id', '');
    if ($id == '')
      $id = getOrDefault('record_id', '');

    $file = getOrDefault('file', '');
    $smarty->assign('id', $id);
    if ($id != '') {
      list($file, $xml) = $this->getXml($file, $id);
      if ($this->action == 'downloadRecord') {
        $this->outputType = 'none';
        $this->downloadContent($xml, 'record.xml', 'application/xml');
      } else {
        $smarty->assign('record', $xml);
        $smarty->assign('xml', $this->asHtml($xml));
        $smarty->assign('issues', $this->getIssues($file, $id));
        $smarty->assign('filename', $file); // $this->db->fetchValue($this->db->getFilenameByRecordId($id), 'file'));
        $smarty->assign('filedata', $this->db->getFileDataByRecordId($file, $id)->fetch(PDO::FETCH_ASSOC));
      }
    }
    $smarty->assign('file', $file);

    if ($this->action == 'downloadFile') {
      $filename = $this->db->fetchValue($this->db->getFilenameByRecordId($id), 'file');
      // error_log('filename: ' . $filename);
      $this->outputType = 'none';
      $this->downloadFile($filename, 'application/xml');
    } elseif ($this->action == 'pdf') {
      $smarty->assign('displayType', 'pdf');
      $html = $smarty->fetch("record.tpl");
      $this->createPdf($html);
    } else {
      $smarty->assign('displayType', 'html');
    }
  }

  public function getTemplate() {
    return 'record.tpl';
  }

  public function getAjaxTemplate() {
    return null;
  }

  public function getXml($file, $id): array {
    error_log('Record::getXml()');
    error_log($this->outputDir . 'ddb-record.sqlite');
    $db = new IssuesDB($this->outputDir, 'ddb-record.sqlite');
    error_log('id: ' . $id);
    error_log('file: ' . $file);
    if (preg_match('/\\\\x/', $file))
      error_log('file has X');
    if (preg_match('/für/', $file))
      error_log('file has Y');
    if (preg_match('/[^a-zA-Z0-9\\/_]/', $file, $matches)) {
      error_log('file has matches: "' . var_export($matches, true) . '"');
      $res = $db->getRecord('', $id)->fetchArray(SQLITE3_ASSOC);
    } else {
      $res = $db->getRecord($file, $id)->fetchArray(SQLITE3_ASSOC);
    }
    if ($file == '')
      $file = $res['file'];
    return [$file, $res['xml']];
  }

  private function getIssues($file, $id) {
    if (preg_match('/([^a-zA-Z0-9\\/_])/', $file, $matches)) {
      error_log('file matches: ' . json_encode($matches));
      $issues = $this->db->getIssuesByFileAndRecordId('', $id)->fetch(PDO::FETCH_ASSOC);
    } else {
      error_log('file does not matches');
      $issues = $this->db->getIssuesByFileAndRecordId($file, $id)->fetch(PDO::FETCH_ASSOC);
    }
    if (is_array($issues)) {
      unset($issues['metadata_schema']);
      unset($issues['filename']);
      unset($issues['recordId']);
      unset($issues['providerid']);
      foreach ($issues as $key => $value) {
        if (preg_match('/^(.*):(.*)$/', $key, $matches)) {
          unset($issues[$key]);
          $key2 = $matches[1] == 'ruleCatalog' ? 'total' : $matches[1];
          if (!isset($issues[$key2])) {
            $issues[$key2] = [];
          }
          $issues[$key2][$matches[2]] = $value;
        }
      }
    } else {
      $issues = [];
    }
    return $issues;
  }

  private function replaceSpace($matches) {
    error_log('replaceSpace:' . $matches[1]);
    return str_replace(" ", "&nbsp;", $matches[1]);
  }

  private function asHtml($xml) {
    error_log('asHtml');
    $html = htmlentities($xml);
    $html = preg_replace_callback('/^( +)/m', [$this, 'replaceSpace'], $html);
    $html = preg_replace("/\r?\n/", "<br/>", $html);
    error_log(substr($html, 0, 1000));
    return $html;
  }
}