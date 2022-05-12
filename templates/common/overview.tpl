<h3>{$count} records</h3>
<p><a href="?tab=downloader&action=downloadFile&subdir={$subdir}">download file</a></p>
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
          {if isset($frequency[$statusId]) && !is_null($frequency[$statusId][0]['value'])}
            {assign var="measured" value=true}
          {else}
            {assign var="measured" value=false}
          {/if}

          <td class="id">{$id}</td>
          <td style="width: 600px"{if !$measured}class="not-measured"{/if}>
            {$factor->description}
            {if $measured}
              {if isset($factor->criterium)}
                <em title='{str_replace('|', "\n", $factor->criterium)}'><i class="fa fa-question"></i></em>
              {/if}
              {if isset($factor->scoring)}
                <div style="margin-left: 1em; color: #666; text-indent: -1em">
                  → <em>scoring</em>: {$factor->scoring}
                </div>
              {/if}
            {/if}
          </td>
          {if isset($frequency[$statusId]) && !is_null($frequency[$statusId][0]['value'])}
            {assign var="passed" value=0}
            {assign var="failed" value=0}
            {assign var="NA" value=0}
            {foreach $frequency[$statusId] as $record name="records"}
              {if $record['value'] == "1"}
                {assign var="passed" value=$record['frequency']}
              {elseif $record['value'] == "0"}
                {assign var="failed" value=$record['frequency']}
              {elseif $record['value'] == "NA"}
                {assign var="NA" value=$record['frequency']}
              {/if}
            {/foreach}
            <td class="bg-passed status">{$passed}</td>
            <td class="bg-failed status">{$failed}</td>
            <td class="bg-NA status">{$NA}</td>
          {else}
            <td class="bg-passed status"></td>
            <td class="bg-failed status"></td>
            <td class="bg-NA status"></td>
          {/if}
          <td>
            {assign var="scoreId" value={$id|cat:':score'}}
            {if isset($frequency[$scoreId]) && !is_null($frequency[$scoreId][0]['value'])}
              <table class="values">
                <tr>
                  <td class="">score</td>
                  {foreach $frequency[$scoreId] as $record name="records"}
                    <td class="value">
                      <a href="?&tab=records&field={$scoreId}&value={$record['value']}{if !empty($schema)}&schema={$schema}{/if}{if !empty($provider_id)}&provider_id={$provider_id}{/if}{if !empty($set_id)}&set_id={$set_id}{/if}">
                        {$record['value']}
                      </a>
                    </td>
                  {/foreach}
                </tr>
                <tr>
                  <td class="">records</td>
                  {foreach $frequency[$scoreId] as $record name="records"}
                    <td class="frequency">{$record['frequency']}</td>
                  {/foreach}
                </tr>
              </table>
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