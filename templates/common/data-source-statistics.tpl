<p class="data-source-statistics">
  <strong>{t}metadata schemas{/t}:</strong>
    {foreach $recordsBySchema as $item name="stat"}
      <a href="?tab={$tab}&schema={$item['id']}&lang={$lang}">{$item['id']}</a>
      <span>({t 1=$item['count']}n.records{/t})</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>
  <strong>{t}data providers{/t}:</strong>
    {foreach $recordsByProvider as $item name="stat"}
      <a href="?tab={$tab}&provider_id={$item['id']}&lang={$lang}">{$item['name']}</a>
      <span>({t 1=$item['count']}n.records{/t})</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>
  <!--
  <strong>{t}datasets{/t}:</strong>
    {foreach $recordsBySet as $item name="stat"}
      <a href="?tab={$tab}&set_id={$item['id']}&lang={$lang}">{$item['name']}</a> <span>&mdash; id:{$item['id']}
      ({t 1=$item['count']}n.records{/t})</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>
  -->
</p>
