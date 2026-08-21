# Secure Vault 🔐🛡️

![Platform](https://img.shields.io/badge/Platform-Android-green?style=for-the-badge&logo=android)
![Security](https://img.shields.io/badge/Security-AES--256-red?style=for-the-badge)
![Biometric](https://img.shields.io/badge/Auth-Biometric-blue?style=for-the-badge)
![Storage](https://img.shields.io/badge/Storage-Local--First-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-Educational-orange?style=for-the-badge)

O **Secure Vault** é um gerenciador de credenciais **local-first** desenvolvido para Android, com foco em privacidade, segurança e armazenamento criptografado.

O sistema permite armazenar credenciais, gerar senhas fortes e proteger o acesso ao cofre utilizando **criptografia AES-256** e **autenticação biométrica**.

> Suas credenciais pertencem a você e devem permanecer protegidas no dispositivo.

---

## 🚀 Funcionalidades

- 🔐 Armazenamento local de credenciais
- 🛡️ Criptografia **AES-256**
- 👆 Autenticação biométrica
- 🔑 Gerador de senhas aleatórias
- ⚙️ Controle configurável do tamanho das senhas
- 📋 Cópia rápida de credenciais
- 👁️ Visualização protegida de senhas
- 📝 Armazenamento de notas associadas às credenciais
- 🌐 Suporte a URL associada à credencial
- 🔎 Verificação de senhas comprometidas em vazamentos
- 📱 Interface otimizada para Android
- 🔒 Arquitetura **local-first**
- 🚫 Sem necessidade de sincronização com servidores externos

---

## 🧠 Arquitetura

```text
                ┌─────────────────────┐
                │      Secure Vault   │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │ Authentication      │
                │ Biometric / Unlock  │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │ Credential Manager  │
                └──────────┬──────────┘
                           │
                ┌──────────┴──────────┐
                ▼                     ▼
       ┌─────────────────┐   ┌─────────────────┐
       │ Password        │   │ Credential      │
       │ Generator       │   │ Management      │
       └─────────────────┘   └────────┬────────┘
                                      │
                                      ▼
                            ┌─────────────────┐
                            │ Encryption      │
                            │ AES-256         │
                            └────────┬────────┘
                                     │
                                     ▼
                            ┌─────────────────┐
                            │ Local Storage   │
                            └─────────────────┘
```

---

## 🔑 Password Generator

O Secure Vault possui um gerador de senhas configurável capaz de produzir credenciais de alta entropia utilizando diferentes conjuntos de caracteres.

O usuário pode controlar o comprimento da senha diretamente através da interface.

Exemplo:

```text
Comprimento: 64

KmxRU0v0@hQ,gtNrG-iVNHw5!ZF4R!x14i_E&{F&b
0Xs6v[M¡@lv.0Tdr30H:VAL
```

---

## 🛡️ Credential Storage

Cada credencial pode armazenar:

| Campo | Descrição |
|---|---|
| Título | Identificação da credencial |
| Usuário / Email | Nome de usuário ou email |
| Senha | Credencial protegida |
| URL | Endereço associado |
| Notas | Informações adicionais |

---

## 🔒 Security Model

O Secure Vault foi projetado seguindo uma abordagem **local-first**.

```text
                Device
                   │
                   ▼
          ┌─────────────────┐
          │ Biometric Auth  │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ Secure Vault    │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ AES-256         │
          │ Encryption      │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ Local Storage   │
          └─────────────────┘
```

O objetivo é minimizar a exposição das credenciais e evitar que informações sensíveis precisem ser armazenadas em infraestrutura externa.

---

## 🔎 Password Leak Detection

O sistema também possui mecanismo para verificar se uma senha foi encontrada em bases conhecidas de vazamentos.

Exemplo:

```text
✅ Não encontrada em vazamentos
```

ou:

```text
⚠️ Encontrada em vazamentos
```

Essa funcionalidade permite identificar credenciais potencialmente comprometidas.

---

## 🛠️ Tecnologias

| Tecnologia | Uso |
|---|---|
| Android | Plataforma |
| [A DEFINIR] | Linguagem principal |
| [A DEFINIR] | UI |
| AES-256 | Criptografia |
| Biometric Authentication | Autenticação |
| [A DEFINIR] | Persistência local |
| [A DEFINIR] | Secure Storage |

> A stack definitiva será documentada após a análise do código-fonte.

---

## 📦 Instalação

Clone o repositório:

```bash
git clone https://github.com/LuizGrochevski/secure-vault.git
cd secure-vault
```

Depois siga as instruções específicas da plataforma.

> A documentação detalhada de build será adicionada após a organização final do projeto.

---

## 📱 Interface

### Tela de desbloqueio

O acesso ao cofre é protegido por autenticação biométrica.

### Cofre

Exibe as credenciais armazenadas localmente.

### Gerador de senhas

Permite gerar senhas com comprimento configurável.

### Editor de credenciais

Permite cadastrar:

- título
- usuário/email
- senha
- URL
- notas

---

## 🧪 Testes

A documentação dos testes será adicionada conforme os componentes do projeto forem estabilizados.

---

## 🛣️ Roadmap

- [x] Cofre local de credenciais
- [x] Gerador de senhas
- [x] Autenticação biométrica
- [x] Interface de gerenciamento de credenciais
- [x] Verificação de vazamentos
- [x] Armazenamento criptografado
- [ ] Testes automatizados completos
- [ ] Exportação segura do vault
- [ ] Importação de credenciais
- [ ] Backup criptografado
- [ ] Rotação de chaves
- [ ] Detecção de senhas reutilizadas
- [ ] Security audit
- [ ] Documentação completa do modelo criptográfico

---

## 👨‍💻 Autor

**Luiz Felipe Grochevski**

[GitHub](https://github.com/LuizGrochevski)

---

## ⚠️ Aviso

Este projeto é destinado a fins educacionais, experimentais e de estudo de segurança de aplicações.

O Secure Vault não deve ser utilizado como único mecanismo de proteção para credenciais críticas sem uma avaliação de segurança independente.

---

## 📄 Licença

Este projeto está disponível sob a licença MIT.
