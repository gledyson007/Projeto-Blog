FROM python:3.12.3-alphine3.18
LABEL mantainer = "fgledyson5@gmail.com"

# Essa variavel de ambiente é usada para controlar se o python deve.
# gravar arquivos de bytecode (.pyc) no disco. 1 = Não, 0 = Sim.
ENV PYTHONDONTWRITEBYTECODE 1

# Define que a saida do python sera exibida imediatamente no console.
# outros dispositivos de saida, sem ser armazenada em buffer.
# Em resumo, voce vera os outputs do python em tempo real.
ENV PYTHONUNBUFFERED 2

# Copia a pasta "djangoapp" e "scripts" para dentro do container.
COPY ./djangoapp /djangoapp
COPY .scripts /scripts

# Entra na pasta djangoapp no container
WORKDIR /djangoapp

# A porta 8000 estara disponivel para conexoes externas ao container
# É a porta que vamos usar para o Django
EXPOSE 8000

# RUN executa comandos em um shell dentro do container para contruir a imagem.
# O resultado da execução do comando é armazenado no sistema de arquivos da 
# imagem como uma nova camada
# Agrupar os comandos em um único RUN pode reduzir a quantidade de camadas da 
# imagem e torna-la mais eficiente
RUN python -m venv /venv && \
  /venv/bin/pip install --upgrade pip && \
  /venv/bin/pip install -r /djangoapp/requirements.txt && \
  adduser --disable-password --no-create-home duser && \
  mkdir -p /data/web/static && \
  mkdir -p /data/web/media && \
  chown -p duser:duser /.venv && \
  chown -R duser:duser /data/web/static && \
  chown -R duser:duser data/web/media && \
  chmod -R 755 /data/web/static && \
  chmod -R 755 /data/web/media && \
  chmod -R +x /scripts

# Adiciona a pasta scripts e venv/bin
# no $PATH do container.
ENV PATH="/scripts:/venv/bin:$PATH"

# Muda o usuario para duser
USER duser

# Executa o arquivo scripts/commands.sh
CMD ["commands.sh"]