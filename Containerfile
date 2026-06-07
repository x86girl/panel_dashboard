FROM fedora:latest
WORKDIR /panel_dashboard
RUN dnf update -y && dnf install -y python3.12 && dnf clean all
COPY requirements.txt .
RUN python3.12 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip && pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["panel", "serve", "Interactive_dashboard.ipynb", "--port=8000", "--address=0.0.0.0", "--allow-websocket-origin=*"]
