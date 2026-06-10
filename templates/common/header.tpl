<diw class="row" style="background-color: brown; background-image: url(https://www.deutsche-digitale-bibliothek.de/assets/ddb-logo-lg-09861113a626a68e170a03d1cba40d51.svg);  background-repeat: no-repeat">
  <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
    <!--a href="." class="header-link"><img class="hidden-xs hidden-sm" width="400"
    src="https://www.deutsche-digitale-bibliothek.de/assets/ddb-logo-lg-09861113a626a68e170a03d1cba40d51.svg"></a-->
  </div>
  <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8 align-bottom" style="vertical-align: bottom !important; color: #333;">
    <h1 style="text-align: right; vertical-align: bottom; margin-top: 100px;" class="align-bottom">
      <i class="fa fa-cogs" aria-hidden="true" style="vertical-align: bottom;"></i> <span style="border-top: 1px solid #fff; border-bottom: 1px solid #fff; padding: 0 0 0 20px;">{t}metadata quality assessment dashboard{/t}</span>
    </h1>
  </div>
</diw>

<diw class="row">
  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
    <i class="fa fa-book" aria-hidden="true"></i>
    <span class="header-info">
      {if $lastUpdate != ''}
       last data update: <strong>{$lastUpdate}</strong>
      {/if}
    </span>
  </div>
  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
    <p style="text-align: right">
      {if $lang == 'en'}English{else}<a href="?lang=en">English</a>{/if} |
      {if $lang == 'de'}Deutsch{else}<a href="?lang=de">Deutsch</a>{/if}
    </p>
  </div>
</diw>

