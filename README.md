# Interactive Dashboard for Upper Limb Rehabilitation

Data analysis dashboard for motor disabilities rehabilitation of the upper limbs using augmented reality (ePuzzle). Built with [Panel](https://panel.holoviz.org/), Plotly, and scikit-learn.

## Features

- Upload and visualize Kinect motion capture CSV files
- Interactive plots for shoulder, elbow, and knee joint angles (left/right)
- Peak detection with signal filtering (Savitzky-Golay)
- Box plot analysis per limb
- Unsupervised clustering (KMeans + PCA) to classify movement patterns

## Requirements

- Python 3.12+

## Local Setup

1. Clone the repository:

```bash
git clone https://github.com/x86girl/panel_dashboard.git
cd panel_dashboard
```

2. Create and activate a virtual environment:

```bash
python3.12 -m venv venv
source venv/bin/activate
```

3. Install dependencies:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

4. Run the dashboard:

```bash
panel serve Interactive_dashboard.ipynb --port=8000 --allow-websocket-origin="*"
```

5. Open your browser at [http://localhost:8000/Interactive_dashboard](http://localhost:8000/Interactive_dashboard).

## Container Setup (Podman/Docker)

1. Build the image:

```bash
podman build -t panel-dashboard .
```

2. Run the container:

```bash
podman run -d -p 8000:8000 panel-dashboard
```

3. Open your browser at [http://localhost:8000/Interactive_dashboard](http://localhost:8000/Interactive_dashboard).

To stop the container:

```bash
podman stop $(podman ps -q --filter ancestor=panel-dashboard)
```

## Usage

1. Click **Choose Files** in the sidebar to upload one or more Kinect CSV session files.
2. Select a limb (shoulder, elbow, or knee) and direction (L/R) from the dropdowns.
3. Navigate between tabs:
   - **Main** — filtered signal plots with peak markers
   - **Details** — matplotlib overlay plot and box plots for the selected file
   - **Documentation** — cluster descriptions and reference charts
