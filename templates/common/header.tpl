<diw class="row" style="background-image: url(https://raw.githubusercontent.com/Deutsche-Digitale-Bibliothek/ddbpro/refs/heads/master/web/themes/custom/ddbp/src/images/logo-ddbpro.svg);  background-repeat: no-repeat">

  <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
    <!--a href="." class="header-link"><img class="hidden-xs hidden-sm" width="400"
    src="https://www.deutsche-digitale-bibliothek.de/assets/ddb-logo-lg-09861113a626a68e170a03d1cba40d51.svg"></a-->
     <h1 style="text-align: right; vertical-align: bottom; margin-top: 100px;" class="site-title align-bottom">
      <i class="fa fa-cogs" aria-hidden="true" style="vertical-align: bottom;"></i> <span style="border-top: 3px solid #EC0A3C; border-bottom: 3px solid #EC0A3C; padding: 0 0 0 0;">{t}metadata quality assessment dashboard{/t}</span>
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

