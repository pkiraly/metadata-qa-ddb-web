<!-- Nav tabs -->
<nav>
  <ul class="nav nav-tabs" id="myTab">
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'overview'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="overview-tab" aria-controls="overview"
         href="?tab=overview&{$controller->getCommonUrlParameters()}">{t}Overview{/t}</a>
    </li>
    <!--
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'records'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="records-tab" aria-controls="records"
         href="?tab=records">{t}Records{/t}</a>
    </li>
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'record'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="record-tab" aria-controls="record"
         href="?tab=record">{t}Record{/t}</a>
    </li>
    -->
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'fair'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="fair-tab" aria-controls="fair"
         href="?tab=fair&{$controller->getCommonUrlParameters()}">{t}FAIR assessment{/t}</a>
    </li>
    <li class="nav-item1">
      <a class="nav-link1{if $tab == 'download'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="download-tab" aria-controls="download"
         href="?tab=download&{$controller->getCommonUrlParameters()}">{t}Download{/t}</a>
    </li>
    <li class="nav-item1">
      <a class="nav-link1{if $tab == 'about'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="about-tab" aria-controls="about"
         href="?tab=about">{t}About{/t}</a>
    </li>
  </ul>
</nav>

<form method="get" action="?">
  <input type="hidden" name="tab" value="{$tab}">
  <input type="hidden" name="lang" value="{$lang}">
  <div class="row">
    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <label class="label label-info" for="schemas">{t}metadata schema{/t}</label><br>
      <select id="schemas" name="schema" style="width: 300px;">
        <option value="">all</option>
        {foreach $schemas as $id => $_schema}
          <option value="{$id}"{if $id == $schema} selected="selected"{/if}>{$id}</option>
        {/foreach}
      </select>
    </div>

    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <label class="label label-info" for="providers">{t}data provider{/t}</label><br>
      <select id="providers" name="provider_id" style="width: 300px;">
        <option value="">all</option>
        {foreach $providers as $id => $provider}
          <option value="{$id}"{if $id == $provider_id} selected="selected"{/if}>{$provider['name']} (id: {$id})</option>
        {/foreach}
      </select>
    </div>
  </div>

  <div class="row">
    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <p style="margin-top: 0.5rem">
        <label class="label label-info col-form-label" for="file">{t}file{/t}</label><br/>
        <input type="text" name="file" id="file" value="{$file}"><br>
        <span style="color: #999999">{t}type in a file name{/t}</span>
      </p>
    </div>
    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <p style="margin-top: 0.5rem">
        <label class="label label-info col-form-label" for="record_id">{t}record ID{/t}</label><br/>
        <input type="text" name="record_id" id="record_id"><br>
        <span style="color: #999999">{t}type in a complete record number{/t}</span>
      </p>
    </div>
    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <p style="margin-top: 2rem" class="text-right">
        <button type="submit" class="btn btn-primary btn-lg">{t}Select{/t}</button>
        <button type="button" class="btr btn-info" onclick="window.location='?';return false;">{t}cancel{/t}</button>
      </p>
      <p>
    </p>
  </div>
</form>
