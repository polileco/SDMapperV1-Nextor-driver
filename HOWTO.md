# Atualização da SDMapper para o Nextor 3.0

Este guia descreve o processo de atualização do firmware/driver da interface **SDMapper** para o **Nextor 3.0**, permitindo também manter compatibilidade com o Nextor 2 (dual-boot).

---

## ⚠️ Avisos Importantes Antes de Começar

1. **Dispositivo Secundário:** É necessário utilizar **outro dispositivo de armazenamento** (como um drive de disquete, Carnivore2, IDE, Pico, PicoVerse, etc.) para dar boot no MSX e executar o programa de atualização (`SDMUPD`).
2. **Backup ou Cartão de Testes:** Faça um **backup completo** do seu cartão SD atual ou utilize um cartão **"descartável"** para testes até ter certeza de que tanto o novo driver da SDMapper quanto o novo kernel do Nextor 3 estão estáveis no seu uso diário.

---

## 1. Atualizando o Firmware da SDMapper

1. Copie o programa atualizador (`SDMUPD.COM`) e o arquivo da nova ROM (com o kernel do Nextor 3.0 + driver da SDMapper) para o seu dispositivo de armazenamento secundário. Os arquivos estão disponíveis na página de [**Releases**](https://github.com/polileco/SDMapperV1-Nextor-driver/releases).
2. Insira a SDMapper e o dispositivo secundário no MSX e ligue o computador.
   > *Dica:* Se o MSX tentar dar boot pela SDMapper antes do dispositivo secundário, segure a tecla **Q/W/E/R** para os slots 1(-0) até 1-3, respectivamente, **A/S/D/F** para os slots 2(-0) até 2-3, respectivamente ou **Z/X/C/V** para os slots 3(-0) até 3-3, respectivamente (dependendo da sua configuração atual - vide [manual do usuário do Nextor 2](https://github.com/Konamiman/Nextor/blob/v2.1.4/docs/Nextor%202.1%20User%20Manual.md#29-boot-keys)) durante o boot logo depois do logo do MSX **ou** deixe a SDMapper sem cartão durante o boot.
3. No prompt do MSX-DOS do dispositivo secundário, acesse a pasta onde estão os arquivos e execute o atualizador:
   ```text
   SDMUPD <nome_do_arquivo.rom>
   ```
   *(Aguarde a conclusão da gravação na flash sem desligar o MSX).*
4. Ao final do processo, reinicie o MSX. A tela de inicialização já deverá exibir o **Nextor 3.0** e a nova versão do driver da SDMapper.

---

## 2. Preparando o Cartão SD (e mantendo Dual-Boot com Nextor 2)

Agora é preciso preparar o cartão SD com os arquivos de sistema e utilitários do Nextor 3.0. Se você usa este mesmo cartão em outras interfaces que ainda rodam o Nextor 2, você pode configurar um esquema de **dual-boot**:

1. Baixe o pacote com os novos programas e utilitários do Nextor 3.0 (seção *Tools disk image and ZIP file for Nextor 3.0*):
   * 🔗 [Releases do Nextor no GitHub](https://github.com/Konamiman/Nextor/releases#release-tools-disk-image-and-zip-for-Nextor-3.0)
2. Descompacte o arquivo `.zip` no seu computador.
3. No cartão SD, crie uma **nova pasta** (por exemplo, `NEXTOR3` ou `UTILS3`) e copie para dentro dela o conteúdo da pasta `TOOLS` do pacote baixado. Isso evita sobrescrever os comandos antigos do Nextor 2. Voce pode _mesclar/sobreescrever_ os arquivos da pasta `HELP`, caso exista, na **raiz** do cartão SD.
4. Na **raiz** do cartão SD, copie os arquivos `NEXTOR.SYS` e `COMMAND3.COM`.
   * **Atenção para o Dual-Boot:** O kernel do Nextor 3 procura primeiro pelo arquivo `NEXTOR3.SYS` antes de carregar o `NEXTOR.SYS`. Portanto, se você quiser manter o `NEXTOR.SYS` original (versão 2) funcionando em outros cartuchos, **renomeie o novo arquivo para `NEXTOR3.SYS`** antes de copiá-lo para a raiz do cartão.
   * *(Opcional)* O Nextor 3 agora utiliza o arquivo `AUTOEXEC.BTM` para a inicialização automática do sistema (deixando o `AUTOEXEC.BAT` livre para o Nextor 2 / MSX-DOS). Você pode criar um específico para a nova versão ou copiar o `AUTOEXEC.BAT` para `AUTOEXEC.BTM`
   ```text
   A:\>COPY AUTOEXEC.BAT AUTOEXEC.BTM
   ```

---

## 3. Finalização

Insira o cartão SD na SDMapper e reinicie o MSX. O sistema deverá carregar o `NEXTOR3.SYS` e o `COMMAND3.COM` automaticamente.

> **Nota:** Recomenda-se a leitura da documentação oficial do Nextor 3.0 ([O que há de novo](https://github.com/Konamiman/Nextor/blob/master/docs/Nextor_3.0_Whats_New.md), [Guia de Introdução](https://github.com/Konamiman/Nextor/blob/master/docs/Nextor_3.0_Getting_Started_Guide.md) e [Manual do usuário](https://github.com/Konamiman/Nextor/blob/master/docs/Nextor_3.0_User_Manual.md)) no repositório do Konamiman, pois há novos comandos, mudanças no gerenciamento de partições e novidades importantes no sistema.

