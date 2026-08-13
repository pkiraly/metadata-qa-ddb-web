{include 'common/html-head.tpl'}
<div class="container">
    {include 'common/header.tpl'}
    {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="about" role="tabpanel" aria-labelledby="about-tab">
      <div id="about-tab">

        <p>
          Dieses Dashboard wurde in Zusammenarbeit mit der
          <a href="https://www.deutsche-digitale-bibliothek.de/" about="_blank">Deutchse Digitale Bibliothek</a> (DDB) und der
          <a href="https://gwdg.de" about="_blank">Gesellschaft für wissenschaftliche Datenverarbeitung mbH Göttingen</a>
          (GWDG) entwickelt. Mitwirkende: Francesca Schulze (DDB), Cosmina Berta (DDB), Stefanie Rühle (DDB), Birgit Armbruster (DDB), Jennifer Treu (DDB), Claudia Effenberger (DDB), 
          Julianne Stiller (Grenzenlos Digital e.V.), Péter Király (GWDG).
        </p>

        <p>Dies ist ein Open-Source-Projekt. Den Quellcode finden Sie unter:</p>
        <ul>
          <li><a href="https://github.com/pkiraly/metadata-qa-api" target="_blank">Metadata Quality Assessment Framework</a></li>
          <li><a href="https://github.com/pkiraly/metadata-qa-ddb" target="_blank">benutzerdefinierte DDB-Auswertungen (Java)</a></li>
          <li><a href="https://github.com/pkiraly/metadata-qa-ddb-web" target="_blank">Web-Oberfläche (PHP)</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>
{include 'common/html-footer.tpl'}