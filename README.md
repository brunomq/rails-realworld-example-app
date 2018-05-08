# ![Rails Example App](project-logo.png)

> Implementação de um container para execução da aplicação disponível em https://github.com/gothinkster/rails-realworld-example-app
# Docker

Essa imagem de container se baseia na imagem ruby:2.2.10-slim a escolha por essa imagem base se deve principalmente a dois motivos:

1- A imagem padrão do ruby é bastante inchada, se fosse utiliza-la o tamanho final da imagem iria se aproximar de 1GB de tamanho o que se distanciaria bastante de um dos objetivos do desafio que era o de tentar reduzir o tamanho da imagem.

2- Foi escolhida a versão 2.2.10 do ruby já que por se tratar de uma aplicação que utiliza algumas versões antigas de bibliotecas do ruby (optei por não realizar nenhum tipo de alteração no Gemfile, já que o desafio era criar um container de uma aplicação existente considerei uma restrição não realizar nenhum tipo de alteração nos arquivos da mesma) a aplicação  apresentou alguns problemas em ser executada em versões mais atuais do container, escolhi a versão 2.2 por se tratar da versão de ruby que é referenciada nos arquivos da aplicação e acreditei não possuir nenhum tipo de incompatibilidade por isso.

Por praticidade disponibilizei a imagem no docker hub com a tag **brunoppl/rails-app**, o Dockerfile da imagem está presente neste repositório.

Após validados o build e start do container, e feitos alguns testes usando o curl para realizar requests para a api criada por essa aplicação de acordo com a [documentação](https://github.com/gothinkster/realworld/tree/master/api) da mesma  parti para a configuração do kubernetes.

#Kubernetes

Criei um cluster local usando o minikube e usando o enunciado como uma especie de checklist fui criando os itens solicitados no Kubernetes.
Para facilitar os testes  criei os seguintes recursos como arquivos separados.

**Deployment** - Criado o arquivo **railsapp_deployment.yml**, neste arquivo foram feitas as definições iniciais como numero de replicas 3, porta de serviço 3000, criar os containers a partir do que disponibilizei no docker hub, e definidos alguns limites para memoria e cpu.

**Horizontal Pod Autoscaler** - Criado o arquivo **hpa-v2.yaml** especificando que o numero de replicas deve oscilar entre 3 e 10 e o valor como meta para orientar o scaling é 50% de CPU.  

**Ingress ou Balancer** - Criado o arquivo **railsapp-service.yaml** para agir como load balancer na aplicação expondo a porta 80 e redirecionando para a porta 3000 de todos os containers no deployment railsapp. Escolhi o load balancer ao inves do ingress por considerar que não iria direcionar os requests de acordo com a url/path dos mesmos, tornando desnecessário fazer o balanceamento pela camada 7. Como iria direcionar os todos os requests que chegassem pela porta certa optei por usar um balancer que opera somente na camada de rede mesmo. Cheguei até a montar um arquivo **railsapp-ingress.yaml** que está presente no repositório mas acabei não utilizando o mesmo.

**Resource Quotas** - Implementado no arquivo  **railsapp-resources.yaml**. Estipulei uma cota de recursos a serem criados no cluster somente para efeito demonstrativo.

**Secrets** - Esse item infelizmente acabei descartando por não conseguir achar uma boa aplicação para o mesmo nesse caso de uso, poderia ter conseguido aplicar se tivesse escolhido uma das outras alternativas de aplicação que implementam databases externos como postgreSQL.

Além desses arquivos, consolidei há um arquivo de nome **railsapp-kubernetes.yaml** com toda a configuração unificada de modo a facilitar o deploy do ambiente. A validação dessa configuração realizei em um ambiente minikube local mas imagino que não seja problema funcionar em outro provedor já não identifiquei nenhum ponto na implementação que amarre a configuração e execução a um ambiente especifico.







