<h3>{$count} records</h3>
{if $displayType == 'html'}
  {include 'common/data-source-statistics.tpl'}
{/if}

<p>average score: <strong>{sprintf("%.2f", $totalScore)}</strong> (not measured: {$notMeasured} records)</p>

<div><caption>score distribution</caption></div>
<svg class="histogram-chart" width="960" height="300"></svg>
<script src="libs/d3.v5.min.js"></script>
<script src="js/histogram.js" type="text/javascript"></script>
<script>
const count = {$count};
const link = '?&tab=records&field=ruleCatalog:score&{$controller->getCommonUrlParameters()}&value=';
const histogramDataUrl = '?tab=overview&action=downloadRuleCatalogScores&{$controller->getCommonUrlParameters()}';
{literal}
const units = 'scores';
const histogramSvgClass = 'histogram-chart';

const tooltip = d3.select("body")
    .append("div")
    .style("opacity", 0)
    .attr("class", "tooltip")
    .attr("id", "tooltip")
displayHistogram(histogramDataUrl, histogramSvgClass);
{/literal}
</script>

<table id="criteria-table">
  <thead>
  <tr>
    <th colspan="2">criterium</th>
    <th class="bg-passed status">passed</th>
    <th class="bg-failed status">failed</th>
    <th class="bg-NA status">NA</th>
    <th></th>
  </tr>
  </thead>
  <tbody>
    {foreach $factors as $id => $factor}
      {if $id != 'file'}
        <tr class="{if $factor->isGroup}criteria-group{else}criterium{/if}">
          {assign var="statusId" value={$id|cat:':status'}}
          {if isset($frequency[$statusId]) && (
               (isset($criteria) && in_array($statusId, $criteria)) 
            || !is_null($frequency[$statusId][0]['value']))}
            {assign var="measured" value=true}
          {else}
            {assign var="measured" value=false}
          {/if}

          {* id *}
          <td class="id{if !$measured} not-measured{/if}">{$id}</td>
          {* description *}
          <td class="description {if !$measured} not-measured{/if}">
            {$factor->description}
            {if $measured}
              {if isset($factor->criterium)}
                <em title='{str_replace('|', "\n", $factor->criterium)}'><i class="fa fa-question"></i></em>
              {/if}
            {/if}
          </td>

          {* status *}
          {if isset($frequency[$statusId]) && !is_null($frequency[$statusId][0]['value'])}
            {assign var="passed" value=0}
            {assign var="failed" value=0}
            {assign var="NA" value=0}
            {foreach from=$frequency[$statusId] item=$record name="records"}
              {if $record['value'] == "1" || $record['value'] == "TRUE"}
                {assign var="passed" value=$record['frequency']}
              {elseif $record['value'] == "0" || $record['value'] == "FALSE"}
                {assign var="failed" value=$record['frequency']}
              {elseif $record['value'] == "NA"}
                {assign var="NA" value=$record['frequency']}
              {/if}
            {/foreach}
            <td class="bg-passed status">
              {include file='common/overview.status.tpl' statusCount=$passed statusValue='1'}
            </td>
            <td class="bg-failed status">
              {include file='common/overview.status.tpl' statusCount=$failed statusValue='0'}
            </td>
            <td class="bg-NA status">
              {include file='common/overview.status.tpl' statusCount=$NA statusValue='NA'}
            </td>
          {else}
            <td {if $measured}class="bg-passed status"{/if}></td>
            <td {if $measured}class="bg-failed status"{/if}></td>
            <td {if $measured}class="bg-NA status"{/if}></td>
          {/if}

          {* score *}
          <td>
            {if !in_array($id, $blockers)}
              {assign var="scoreId" value={$id|cat:':score'}}
              {if isset($frequency[$scoreId]) && !is_null($frequency[$scoreId][0]['value'])}
                <table class="values">
                  <tr>
                    <td class="label">
                      score
                      {if isset($factor->scoring)}
                        <em title='{$factor->scoring}'><i class="fa fa-question"></i></em>
                      {/if}
                    </td>
                    {foreach $frequency[$scoreId] as $record name="records"}
                      {if !is_null($record['value']) && $record['value'] != 'NA'}
                        <td class="value">
                          {if $displayType == 'html'}
                            <a href="?&tab=records&field={$scoreId}&value={$record['value']}&{$controller->getCommonUrlParameters()}">
                              {$record['value']}
                            </a>
                          {else}
                            {$record['value']}
                          {/if}
                        </td>
                      {/if}
                    {/foreach}
                  </tr>
                  <tr>
                    <td class="">records</td>
                    {foreach $frequency[$scoreId] as $record name="records"}
                      {if !is_null($record['value']) && $record['value'] != 'NA'}
                        <td class="frequency">{$record['frequency']}</td>
                      {/if}
                    {/foreach}
                  </tr>
                </table>
              {/if}
            {/if}
          </td>
        </tr>
      {/if}
    {/foreach}
  </tbody>
</table>

<p>
  Criteria that are not yet implemented, or not applicable to a particular metadata schema,
  are <span style="color: #cccccc;">greyed out</span>
</p>

{if $displayType == 'html'}
  <p>
    <a href="?tab=overview&action=pdf&schema={$schema}&set_id={$set_id}&provider_id={$provider_id}&lang={$lang}" target="_blank">PDF</a>
    -
    download CSV:
    <a href="?tab=overview&action=downloadStatus&schema={$schema}&set_id={$set_id}&provider_id={$provider_id}&lang={$lang}">status</a>
    <a href="?tab=overview&action=downloadScores&schema={$schema}&set_id={$set_id}&provider_id={$provider_id}&lang={$lang}">score</a>
  </p>
{/if}