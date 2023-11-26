FROM fedora:latest
WORKDIR /
RUN dnf update -y
RUN dnf install git python39 -y
RUN git clone https://github.com/x86girl/panel_dashboard.git
RUN python3.9 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip
WORKDIR /panel_dashboard
RUN pip install -r ./requirements.txt
EXPOSE 8000
RUN mkdir /data
WORKDIR /
CMD /bin/bash -c 'panel serve /panel_dashboard/Interactive_dashboard.ipynb --port=8000'
