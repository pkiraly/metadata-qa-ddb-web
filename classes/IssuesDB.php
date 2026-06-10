<?php

class IssuesDB extends SQLite3 {
  private $db;

  function __construct($dir, $file = 'ddb.sqlite') {
    $file = $dir . '/' . $file;
    $this->open($file);
  }

  public function getIssuesCount($field, $value, $schema = '', $provider_id = '', $set_id = '') {
    // error_log($field . ' -- ' . $value);
    // error_log(sprintf('%s %s %s', $schema, $provider_id, $set_id));
    $where = $this->getWhere($schema, $provider_id, $set_id, FALSE);
    if ($where == '') {
      $sql = 'SELECT COUNT(*) AS count
       FROM issue AS i
       WHERE `' . $field . '` = :value';
    } else {
      $sql = 'SELECT COUNT(*) AS count
        FROM issue AS i
        LEFT JOIN file_record fr ON (fr.recordId = i.recordId)
        LEFT JOIN files AS f ON (fr.file = f.file)
        WHERE `' . $field . '` = :value AND ' . $where;
    }
    // error_log(cleanSql($sql));
    $stmt = $this->prepare($sql);
    $stmt->bindValue(':value', $value, preg_match('/:score$/', $field) ? SQLITE3_INTEGER : SQLITE3_TEXT);
    if ($where != '')
      $this->bindValues($schema, $provider_id, $set_id, $stmt);

    // error_log(cleanSql($stmt->getSQL(TRUE)));
    return $stmt->execute();
  }

  public function getIssues($field, $value, $schema = '', $provider_id = '', $set_id = '', $offset = 0, $limit = 10)
  {
    // error_log($field . ' -- ' . $value);
    // error_log(sprintf('%s %s %s', $schema, $provider_id, $set_id));
    $default_order = 'recordid';
    $where = $this->getWhere($schema, $provider_id, $set_id, FALSE);
    if ($where == '') {
      $sql = 'SELECT i.*
       FROM issue AS i
       WHERE `' . $field . '` = :value
       ORDER BY ' . $default_order . '
       LIMIT :limit
       OFFSET :offset';
    } else {
      $sql = 'SELECT i.*
       FROM issue AS i
       LEFT JOIN file_record fr ON (fr.recordId = i.recordId)
       LEFT JOIN files AS f ON (fr.file = f.file)
       WHERE `' . $field . '` = :value AND ' . $where . '
       ORDER BY ' . $default_order . ' 
       LIMIT :limit
       OFFSET :offset';
    }
    // error_log(cleanSql($sql));
    $stmt = $this->prepare($sql);
    $stmt->bindValue(':value', $value, preg_match('/:score$/', $field) ? SQLITE3_INTEGER : SQLITE3_TEXT);
    if ($where != '')
      $this->bindValues($schema, $provider_id, $set_id, $stmt);
    $stmt->bindValue(':offset', $offset, SQLITE3_INTEGER);
    $stmt->bindValue(':limit', $limit, SQLITE3_INTEGER);
    // error_log(cleanSql($stmt->getSQL(TRUE)));

    return $stmt->execute();
  }

  public function getIssuesByRecordId($id) {
    $default_order = 'recordid';
    $stmt = $this->prepare('SELECT * FROM issue WHERE recordId = :value');
    $stmt->bindValue(':value', $id, SQLITE3_TEXT);

    return $stmt->execute();
  }

  public function countIssues($field, $value) {
    $default_order = 'recordid';
    $stmt = $this->prepare('SELECT count(*) AS count
       FROM issue
       WHERE `' . $field . '` = :value
    ');
    $stmt->bindValue(':value', $value, SQLITE3_TEXT);

    return $stmt->execute();
  }

  public function getCount($schema = 'NA', $provider_id = 'NA', $set_id = 'NA') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT count FROM count ' . $where);
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    return $stmt->execute();
  }

  public function getFrequency($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT field, value, frequency FROM frequency ' . $where);
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    // error_log(cleanSql($stmt->getSQL(TRUE)));

    return $stmt->execute();
  }

  public function getVariablitily($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT field, number_of_values FROM variability ' . $where);
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    // error_log(cleanSql($stmt->getSQL(TRUE)));

    return $stmt->execute();
  }

  public function getRecord($file, $id): SQLite3Result {
    if ($file != '') {
      $stmt = $this->prepare('SELECT xml FROM record WHERE file = :file AND id = :id');
      $stmt->bindValue(':file', $file, SQLITE3_TEXT);
    } else {
      $stmt = $this->prepare('SELECT file, xml FROM record WHERE id = :id');
    }
    $stmt->bindValue(':id',   $id,   SQLITE3_TEXT);

    return $stmt->execute();
  }

  public function listSchemas($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT schema, COUNT(*) AS count
      FROM files '
      . $where
      . ' GROUP BY schema ORDER BY schema');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    return $stmt->execute();
  }

  public function listProviders($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT provider_id AS id, provider_name AS name, COUNT(*) AS count FROM files  ' . $where . ' GROUP BY provider_id, provider_name');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    return $stmt->execute();
  }

  public function listSets($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT set_id AS id, set_name AS name, COUNT(*) AS count FROM files ' . $where . ' GROUP BY set_id, set_name');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    return $stmt->execute();
  }

  public function getFilenameByRecordId($record_id = '') {
    $stmt = $this->prepare('SELECT file FROM file_record WHERE recordId = :record_id');
    $stmt->bindValue(':record_id', $record_id, SQLITE3_TEXT);
    return $stmt->execute();
  }

  public function countRecordsBySchema($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT schema AS id, COUNT(*) AS count
FROM files AS f
INNER JOIN file_record AS r
USING (file) ' . $where . ' GROUP BY schema');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    // error_log(cleanSql($stmt->getSQL(TRUE)));
    return $stmt->execute();
  }

  public function countRecordsByProvider($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT provider_id AS id, COUNT(*) AS count
FROM files AS f
INNER JOIN file_record AS r
USING (file) ' . $where . ' GROUP BY provider_id');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    return $stmt->execute();
  }

  public function countRecordsBySet($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->prepare('SELECT set_id AS id, COUNT(*) AS count
FROM files AS f
INNER JOIN file_record AS r
USING (file) ' . $where . ' GROUP BY set_id');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    return $stmt->execute();
  }

  public function fetchValue(SQLite3Result $result, $key) {
    return $result->fetchArray(SQLITE3_ASSOC)[$key];
  }

  public function fetchList(SQLite3Result $result, $key) {
    $items = [];
    while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
      $items[] = $row[$key];
    }
    return $items;
  }

  public function fetchAssoc(SQLite3Result $result, $key = 'id') {
    $items = [];
    while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
      $items[$row[$key]] = $row;
    }
    return $items;
  }

  public function fetchAssocList(SQLite3Result $result, $key = 'id') {
    $items = [];
    while ($item = $result->fetchArray(SQLITE3_ASSOC)) {
      $key_val = $item[$key];
      unset($item[$key]);
      if (!isset($items[$key_val])) {
        $items[$key_val] = [];
      }
      $items[$key_val][] = $item;
    }
    return $items;
  }

  /**
   * @param $schema
   * @param $provider_id
   * @param $set_id
   * @return string
   */
  private function getWhere($schema, $provider_id, $set_id, $prefix = TRUE): string
  {
    if ($schema != '' || $provider_id != '' || $set_id != '') {
      $criteria = [];
      if ($schema != '')
        $criteria[] = 'schema = :schema';
      if ($provider_id != '')
        $criteria[] = 'provider_id = :provider_id';
      if ($set_id != '')
        $criteria[] = 'set_id = :set_id';
      $where = ($prefix ? ' WHERE ' : '') . join(' AND ', $criteria);
    } else {
      $where = '';
    }
    return $where;
  }

  /**
   * @param $schema
   * @param $provider_id
   * @param $set_id
   * @param $stmt
   * @return void
   */
  private function bindValues($schema, $provider_id, $set_id, &$stmt): void
  {
    if ($schema != '' || $provider_id != '' || $set_id != '') {
      if ($schema != '')
        $stmt->bindValue(':schema', $schema, SQLITE3_TEXT);
      if ($provider_id != '')
        $stmt->bindValue(':provider_id', $provider_id, SQLITE3_TEXT);
      if ($set_id != '')
        $stmt->bindValue(':set_id', $set_id, SQLITE3_TEXT);
    }
  }
}