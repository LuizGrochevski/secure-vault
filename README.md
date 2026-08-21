# Secure Vault 🔐🛡️

![Platform](https://img.shields.io/badge/Platform-Android-green?style=for-the-badge&logo=android)
![Security](https://img.shields.io/badge/Security-AES--256-red?style=for-the-badge)
![Biometric](https://img.shields.io/badge/Auth-Biometric-blue?style=for-the-badge)
![Storage](https://img.shields.io/badge/Storage-Local--First-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-Educational-orange?style=for-the-badge)

O **Secure Vault** é um gerenciador de credenciais **local-first** desenvolvido para Android, com foco em privacidade, segurança e armazenamento criptografado.

O sistema permite armazenar credenciais, gerar senhas fortes e proteger o acesso ao cofre utilizando **criptografia AES-256** e **autenticação biométrica**.

A proposta é simples:

> suas credenciais pertencem a você e devem permanecer protegidas no dispositivo.

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
