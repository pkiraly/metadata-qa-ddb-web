<div class="tab-pane active" id="record" role="tabpanel" aria-labelledby="factors-tab">
  <h2>Record view {if (isset($id) && !empty($id))}<span>{$id}</span>{/if}</h2>

  {if (!isset($id) || empty($id))}
    <p>No record identifier has been given.</p>
  {elseif ((!isset($record) || empty($record)) && (!isset($issues) || empty($issues)))}
    <p>This record does not exist. Type in a complete record number!</p>
  {else}

    <ul>
      <li>metadata schema: {$filedata['metadata_schema']}</li>
      <li>provider: {$filedata['provider_name']}</li>
      <li>dataset name: {$filedata['set_name']}</li>
      <li>file: {$filedata['file']}</li>
      <li>last modified: {$filedata['datum']}</li>
      <li>file size: {$filedata['size']}</li>
    </ul>

    <p>
      [<a href="#criteria">{t}criteria{/t}</a>]
      [<a href="#content">{t}XML content{/t}</a>]
    </p>

    <table id="criteria">
      <thead>
        <th>id</th>
        <th>description</th>
        <th>status</th>
        <th>score</th>
      </thead>
      <tbody>
      {foreach $issues as $id => $value}
        {if $id != 'recordId' && $id != 'providerid'}
          <tr>
            <td class="id">{$id}</td>
            <td class="factor">
              {if isset($factors[$id])}
                {$factors[$id]->description}
                {if isset($factors[$id]->criterium)}
                  <em title='{str_replace('|', "\n", $factors[$id]->criterium)}'><i class="fa fa-question"></i></em>
                {/if}
              {/if}
            </td>
            {if isset($value['status'])}
              <td class="result {if $value['status'] == "1"}passed{elseif $value['status'] == "0"}failed{else}{$value['status']}{/if}">
                {if $value['status'] == "1"}passed{elseif $value['status'] == "0"}failed{else}{$value['status']}{/if}
              </td>
            {else}
              <td></td>
            {/if}
            <td class="result">
              {if isset($value['score'])}
                {$value['score']}
                {if isset($factors[$id]->scoring)}
                  <em title='{$factors[$id]->scoring}'><i class="fa fa-question"></i></em>
                {/if}
              {/if}
            </td>
          </tr>
        {/if}
      {/foreach}
      </tbody>
    </table>

    <div id="xml-content">{$xml}</div>

    {if $displayType == 'html'}
      <p>
        <a href="?tab=downloader&action=downloadRecord&id={$id}&file={$file|urlencode}">download record</a>
        &mdash;
        <a href="?tab=downloader&action=downloadFile&id={$id}">download file</a>
        &mdash;
        <a href="?tab=record&action=pdf&id={$id}&file={$file}&schema={$schema}&set_id={$set_id}&provider_id={$provider_id}&lang={$lang}" target="_blank">PDF</a>
      </p>
    {/if}
  {/if}{* the $record is available *}
</div>
