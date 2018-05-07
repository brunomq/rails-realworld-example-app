# ![Rails Example App](project-logo.png)

> Implementação de um container para execução da aplicação disponível em https://github.com/gothinkster/rails-realworld-example-app

Essa imagem de container se baseia na imagem ruby:2.2.10-slim, por se tratar de uma aplicação que utiliza algumas versões antigas de bibliotecas do ruby ela apresentou alguns problemas em ser executadas em versões mais atuais do container escpçhir a versão 2.2 por se tratar da versão de ruby que é referenciada nos arquivos da aplicação. 

O container está disponivel no docker hub com a tag brunoppl/rails-app

A configuração do Kubernets está disposta nos vários arquivos yaml dispostos no repositório contendo o deployment, load balancer service, horizontal pod autoscaler e resource limits. Somente não consegui ver um jeito de aplicar secrets nesa implementação. 





