<?php
include_once 'common-functions.php';

$smarty = createSmarty('templates');

$tab = getOrDefault('tab', 'overview', ['overview', 'records', 'record', 'about', 'downloader', 'fair', 'download']);
$ajax = getOrDefault('ajax', 0, [0, 1]);
$language = 'de'; // getOrDefault('lang', 'de', ['en', 'de']);

$map = [
  'overview' => 'Overview',
  'factors'  => 'Overview',
  'records'  => 'Records',
  'record'   => 'Record',
  'about'    => 'About',
  'downloader' => 'Downloader',
  'fair' => 'Fair',
  'download' => 'Download',
];

include_once('classes/Tab.php');
include_once('classes/BaseTab.php');
include_once('classes/DdbLocale.php');
$locale = new DdbLocale($language);
$class = isset($map[$tab]) ? $map[$tab] : 'Completeness';
$controller = createTab($class);
$controller->prepareData($smarty);

if ($ajax == 1) {
  if (!is_null($controller->getAjaxTemplate()))
    $smarty->display($controller->getAjaxTemplate());
} elseif ($controller->getOutputType() == 'html')
  $smarty->display($controller->getTemplate());
