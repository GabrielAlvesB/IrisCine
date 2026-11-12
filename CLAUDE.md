# IrisCine — instruções para agentes

## LEIA PRIMEIRO: o IrisCine é uma cópia modificada do FilmCraft

**Esta seção vale mais que todo o resto (inclusive o `AGENTS.md`, que veio do FilmCraft).** Onde o resto contradizer esta seção, esta seção vence.

O IrisCine é uma cópia (fork) do [FilmCraft](https://github.com/storytold/filmcraft), da equipe ArtCraft, adaptada para o ecossistema Iris por **Gabriel Alves Tech**. O repositório é `GabrielAlvesB/IrisCine` (remote `origin`); o FilmCraft original é o remote `upstream`, usado **só para trazer atualizações**: nunca envie nada para ele.

Todos os ajustes listados abaixo foram feitos de propósito. **Nenhuma atualização vinda do FilmCraft pode desfazê-los.** Ao trazer uma versão nova, o trabalho é incorporar as melhorias do FilmCraft **mantendo o IrisCine como ele é**. Em qualquer conflito entre o código do FilmCraft e um ajuste do IrisCine, fica o do IrisCine. Na dúvida, pergunte ao dono antes de mudar.

### O que é do IrisCine e não pode ser revertido

1. **Nome visível "IrisCine"** em tudo que o usuário vê: título da janela, Sobre, menus, mensagens, nomes de decodificadores, pastas de dados (`IrisCine`, `IrisCine Previews`, `IrisCine Media Cache`), metadados gravados em arquivos exportados (AAF/OMF/MXF/MCC/XMP/DPX/LUT), README, instaladores e pacotes. "FilmCraft" só aparece nos créditos e avisos de copyright (`LICENSE-MIT`, `NOTICE`, a seção de licença do README, "Based on FilmCraft"); esses avisos são exigidos pela licença e não podem ser removidos.
2. **Traduções**: os catálogos ficam em `crates/ui-egui/src/i18n/*.tsv` e a chave é o texto em inglês. Texto novo do FilmCraft com "FilmCraft" vira "IrisCine" **no código e na chave e no valor de cada catálogo**, senão a tradução some. Em línguas que declinam o nome (cs, pl, bs…), use "IrisCine" sem declinar; em turco, os sufixos seguem o "e" final ('yi, 'nin, 'den).
3. **ID do app `com.iris.iriscine`** (nunca `ai.storyteller.filmcraft`): `APP_ID` em `apps/filmcraft/src/main.rs`, `packaging/linux/com.iris.iriscine.*`, os manifests Flatpak, `packaging/macos/Info.plist.in` (inclusive o UTI `com.iris.iriscine.project`), `omastore.toml`, os ícones em `assets/app-icon/hicolor/*/apps/`.
4. **Ícone do IrisCine** (claquete aberta com botão de play, degradê `#ff6a5c` → `#bd44c0`, listras ameixa): a fonte é `assets/app-icon/filmcraft.svg` (copiada para `filmcraft-small.svg`); todo PNG, `.ico`, `.icns`, o `favicon.png` do app web e o fundo do DMG são gerados dela (`packaging/icons.sh`, `packaging/macos/dmg/generate.py`). É marca do Iris, de Gabriel Alves Tech, fora da licença do código. Nunca aceite ícones do FilmCraft por cima destes.
5. **Sem marca ArtCraft**: sem `docs/brand/`, sem `crates/ui-egui/src/brand.rs`, sem links para `getartcraft.com` ou `discord.gg/artcraft`, sem botão de Discord (cabeçalho, Sobre, tela inicial, menu Ajuda, menu nativo do macOS). `crates/ui-egui/src/links.rs` só tem o GitHub e as issues do IrisCine. Se uma atualização trouxer menções novas à ArtCraft ou à suíte Crafting Apps na interface, retire-as. A licença de marca da ArtCraft exige isso de forks.
6. **Atualizador** (`UPDATE_APP` em `crates/ui-egui/src/lib.rs`): `name: "IrisCine"`, `repo: "GabrielAlvesB/IrisCine"` (exatamente assim: o atualizador compara os links diferenciando maiúsculas), `developer: "Gabriel Alves Tech"`, `bundle_id_override: Some("com.iris.iriscine")`. Nunca volte para `craft_update::suite::FILMCRAFT` puro: o app passaria a baixar o FilmCraft por cima do IrisCine. A verificação ao abrir (`set_startup_update_check` em `apps/filmcraft/src/main.rs`) está **desligada** até o repositório publicar a primeira release; ligue-a (`true`) nessa hora.
7. **Instalador do Windows** (`packaging/windows/`): `UpgradeCode` `15D7DE0B-5986-47A0-B84F-26EDE25E142B` e GUID do componente `FilmcraftApp` `A0D0C6CF-DF0B-4009-9117-8356904683A2` (nunca os do FilmCraft, senão um instalador substitui o outro), fabricante `Gabriel Alves Tech`, pasta `Programs\Iris\IrisCine` (`Iris\IrisCine` em Arquivos de Programas), chaves de registro `Software\IrisCine`. Em `apps/filmcraft/build.rs`, `CompanyName` é `Gabriel Alves Tech`.
8. **Arquivos de projeto compatíveis**: os valores gravados nos arquivos continuam os do FilmCraft, para o IrisCine abrir projetos do FilmCraft e vice-versa: os nomes de renderizador (`RENDERER_GPU`/`RENDERER_SOFTWARE`, só o rótulo mostrado troca para IrisCine), `filmcraft.project`, `metadata.filmcraft` do OTIO, as chaves `FilmCraft …` de AAF/OMF e `FilmCraftGenerator`. Não renomeie.
9. **CI próprio**: `.github/workflows/ci.yml` e `.github/workflows/package.yml` são autocontidos (sem segredos, token só de leitura, actions fixadas por SHA). **Nunca restaure** os workflows do FilmCraft (`storytold/craft-common-actions@...`, release, SonarCloud, FreeBSD, nix, house-rules, packaging-lint, windows-arm64), nem `sonar-project.properties` ou `.coderabbit.yaml`: eles rodam código de outra organização e repassam segredos. A regra 11 das house rules do `AGENTS.md` ("CI stays shared") **não vale aqui**. O Dependabot roda semanalmente (`America/Sao_Paulo`). As fontes da interface vêm de `storytold/craft-fonts` no commit de `craft-fonts.rev`.
10. **Nomes internos mantidos de propósito**: crates `filmcraft-*`, binários `filmcraft`/`filmcraft-cli` (e `filmcraft.exe`), arquivos `assets/app-icon/filmcraft.*` e `packaging/windows/filmcraft.wxs`, variáveis `FILMCRAFT_*`, servidor MCP `filmcraft`, URIs `filmcraft://`, `window.filmcraft` no app web, `filmcraft.log`, o pacote `filmcraft` do .deb/.rpm e os nomes dos arquivos de release (`filmcraft-<versão>-windows-<arq>.msi`, `...-portable.zip`, `filmcraft-<versão>-linux-<arq>.AppImage`…). O atualizador e o Workspace do Iris procuram exatamente esses nomes. Não renomeie.

### Como trazer uma atualização do FilmCraft

1. **Não use `git fetch upstream --tags`**: as tags do FilmCraft têm os mesmos nomes que as nossas terão (`v0.20.1`…) e sobrescreveriam as do IrisCine. Liste com `git ls-remote --tags upstream`, busque só a escolhida com outro nome e faça o merge numa branch: `git fetch --no-tags upstream refs/tags/v0.21.0:refs/tags/upstream-v0.21.0 && git switch -c update-filmcraft-0.21.0 && git merge upstream-v0.21.0`. O remote `upstream` fica com `tagOpt --no-tags` e push desativado.
2. Resolva os conflitos mantendo **tudo** da lista acima. Arquivos removidos no IrisCine (`docs/brand/`, `brand.rs`, workflows antigos, `sonar-project.properties`, `.coderabbit.yaml`) continuam removidos.
3. Procure o que entrou de novo com a marca antiga e adapte: `git grep -n -e FilmCraft -e ArtCraft -e getartcraft -e discord.gg -e ai.storyteller -e storytold/filmcraft -- ':!*.md'`. Texto visível novo vira IrisCine (código **e** catálogos `.tsv`); comentários, avisos de copyright, créditos e os valores de formato do item 8 ficam como estão.
4. Arquivos novos em `.github/workflows/` vindos do FilmCraft: apague. Ícones ou imagens novas de marca: não adote. Se o FilmCraft mudar o `craft-fonts-ref` do `release.yml` dele, copie o commit para `craft-fonts.rev` e atualize `../craft-fonts`.
5. Se a revisão de `craft-libs` mudou, confira se `craft_update::app::App` ainda aceita os campos do `UPDATE_APP`.
6. Rode `cargo xtask assets` e os testes com as fontes (`CRAFT_FONTS_DIR` apontando para `../craft-fonts`, caminho absoluto): `cargo test --workspace --no-fail-fast`.
7. **Versão**: a versão do IrisCine (`[workspace.package]` no `Cargo.toml`) precisa ser **maior que a da última release do IrisCine**, senão o atualizador não oferece a nova. Rode `cargo update -w` depois de mudar.
8. Mostre ao dono o que mudou antes de fazer merge na `main` e de publicar release.

### Como publicar uma release

Os instaladores saem do workflow `.github/workflows/package.yml` (roda em push de branches `update-filmcraft-*`, de tags `v*` ou manualmente): artefato `iriscine-release` com `.msi`, `-portable.zip`, `.AppImage`, `.deb`, `.rpm`, `.tar.gz` e `SHA256SUMS.txt`. Ele não publica nada.

1. Versão nova no `Cargo.toml`, `cargo update -w`, commit e push na `main`.
2. Rode o workflow `Packages` (ou empurre a tag `v<versão>`) e baixe o artefato `iriscine-release`.
3. `SHA256SUMS.txt` fica no formato `hash  nome` (dois espaços, sem `*`). O Workspace do Iris não instala sem ele.
4. `gh release create v<versão> -R GabrielAlvesB/IrisCine --title "IrisCine v<versão>" --notes-file <notas.md> --latest` com os arquivos do artefato. Notas em português.
5. Na primeira release, ligue a verificação ao abrir (item 6 acima).
6. Os builds não têm assinatura Authenticode, então o próprio IrisCine só avisa da versão nova e abre a página da release; a instalação automática acontece pelo Workspace do Iris.

---

@AGENTS.md
