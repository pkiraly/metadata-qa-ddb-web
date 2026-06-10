<?php

class Downloader extends BaseTab {

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);
    $this->outputType = 'none';

    $this->action = getOrDefault('action', 'downloadFile', ['downloadRecord', 'downloadFile', 'csvFile']);
    $id = getOrDefault('id', '');
    $file = getOrDefault('file', '');
    if ($id != '' && $this->action == 'downloadRecord') {
      include_once('Record.php');
      $record = new Record();
      list($file, $xml) = $record->getXml($file, $id);
      $this->downloadContent($xml, 'record.xml', 'application/xml');

    } else if ($this->action == 'downloadFile') {
      $filename = $this->db->fetchValue($this->db->getFilenameByRecordId($id), 'file');
      $contentType = 'application/xml';
      if (preg_match('/^(.*?)::(.*?\.xml)$/', $filename, $matches)) {
        $filename = $matches[1];
        $contentType = 'application/zip';
      }
      $this->outputType = 'none';
      $this->downloadFile($filename, $contentType);

    } else if ($this->action == 'csvFile') {
      include_once('Download.php');
      $filename = getOrDefault('file', '', Download::getAllowableFiles());
      if ($filename != '') {
        $this->outputType = 'none';
        $this->downloadCsv($filename);
      }
    }
  }

  public function getTemplate() {
    return null;
  }

  public function getAjaxTemplate() {
    return null;
  }
}