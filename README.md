# upper-limb-rehab-dashboard

Interactive dashboard for upper limb motor rehabilitation, built as part of a [Master's thesis](https://teses.usp.br/teses/disponiveis/55/55134/tde-21052025-142316/pt-br.html) at ICMC-USP (Institute of Mathematical and Computer Sciences, University of Sao Paulo).

The system processes motion capture data collected during augmented reality rehabilitation sessions (e-puzzle game) and applies unsupervised machine learning to classify patient movement patterns into distinct clusters. An interactive web dashboard allows healthcare professionals to visualize joint angle signals, compare sessions, and monitor patient progress over time.

Built with [Panel](https://panel.holoviz.org/), Plotly, matplotlib, and scikit-learn.

## Features

- Upload and visualize motion capture CSV session files
- Interactive signal plots for shoulder, elbow, and knee joint angles (left/right) with Savitzky-Golay noise filtering
- Automatic peak detection to identify maximum range of motion per session
- Box plot distribution analysis per limb and direction
- Unsupervised patient classification using PCA dimensionality reduction and K-Means clustering (k=3)
- Cluster-based movement profile description to support clinical decision-making

## Requirements

- Python 3.12+

## Local Setup

1. Clone the repository:

```bash
git clone https://github.com/x86girl/upper-limb-rehab-dashboard.git
cd upper-limb-rehab-dashboard
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
podman build -t upper-limb-rehab-dashboard .
```

2. Run the container:

```bash
podman run -d -p 8000:8000 upper-limb-rehab-dashboard
```

3. Open your browser at [http://localhost:8000/Interactive_dashboard](http://localhost:8000/Interactive_dashboard).

To stop the container:

```bash
podman stop $(podman ps -q --filter ancestor=upper-limb-rehab-dashboard)
```

## Usage

1. Click **Choose Files** in the sidebar to upload one or more session CSV files captured by the e-puzzle AR game.
2. Select a limb (shoulder, elbow, or knee) and direction (L/R) from the dropdowns.
3. Navigate between tabs:
   - **Main** — filtered signal plots with peak markers for uploaded sessions
   - **Details** — matplotlib overlay plot, box plots, and cluster prediction for a selected file
   - **Documentation** — cluster descriptions and reference charts

## Citation

If you use this work in your research, please cite:

> GUTIERRES, P. **Treatment support system for upper limb motor rehabilitation**. 2024. 71 p. Dissertation (Master in Science) -- Institute of Mathematical and Computer Sciences, University of Sao Paulo, Sao Carlos, 2024. Available at: https://teses.usp.br/teses/disponiveis/55/55134/tde-21052025-142316/pt-br.html

## License

This project is part of academic research conducted at ICMC-USP in collaboration with LISI/PUC-Campinas and BRAINN (Brazilian Institute for Neuroscience and Neurotechnology).
