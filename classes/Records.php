<?php

include_once 'classes/IssuesDB.php';

class Records extends BaseTab {

  public function __construct() {
    parent::__construct();
  }

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $field = getOrDefault('field', '1.1');
    $value = getOrDefault('value', '');
    // $value = getOrDefault('value', '1', ['0', '1', 'NA']);
    $page = getOrDefault('page', 0);
    $limit = getOrDefault('limit', 100);
    if (preg_match('/^(.*?):(score|status)$/', $field, $matches)) {
      $factor = $matches[1];
      $type = $matches[2];
    } else {
      $factor = $field;
      $type = 'unknown';
    }
    $smarty->assign('factor', $factor);
    $smarty->assign('type', $type);

    $recordCount = $this->count;
    $result = $this->db->getIssues($field, $value,
      $this->unsetNa($this->schema), $this->unsetNa($this->provider_id), $this->unsetNa($this->set_id),
      $page * $limit, $limit
    );
    $recordIds = [];
    while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
      $recordIds[] = $row['recordId'];
    }
    error_log('recordIds: '. join(', ', $recordIds));
    $smarty->assign('recordCount', $recordCount);
    $smarty->assign('page', $page);
    $smarty->assign('limit', $limit);
    $smarty->assign('field', $field);
    $smarty->assign('value', $value);
    $smarty->assign('recordIds', $recordIds);
  }

  public function getTemplate() {
    return 'records.tpl';
  }

}