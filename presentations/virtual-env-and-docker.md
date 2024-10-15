---
marp: true
theme: default
paginate: true
style: |
  section {
    font-size: 34px;
  }
  h1, h2, h3 {
    color: #4CAF50;
    font-size: 60px;
  }
  code {
    background-color: #f5f5f5;
    color: #D32F2F;
    font-size: 40px;
  }
header: 'Virtual Environments & Docker'
---

# Virtual Environments & Docker

---

# The Problem: It Works on My Machine!

- You share your code, and someone else tries to run it...
- **But it doesn’t work.**

Reasons why:
- Different OS (Windows vs. Linux vs. macOS)
- Different software/library versions

---

# Versioning Problems: Why It's an Issue

- Libraries and packages update frequently.
  - Pandas, NumPy, R packages—small changes can break your code.
  
Example:  
  - `pandas.read_csv()` used to take a parameter `error_bad_lines`, which is **deprecated** now.

---

# Virtual Environments: What They Do

- **Isolate** your project dependencies in one place.
- Your project lives in its own "bubble" without conflicting with other projects.

Useful for:
- Ensuring your code runs with the same package versions **every time**.

---

# Steps to Set Up a Virtual Environment

1. **Create** the virtual environment.
2. **Activate** the virtual environment.
3. **Install dependencies** into the environment.
4. **Freeze the dependencies** to a file for others to use.

---

# Step 1: Creating a Virtual Environment (Python)

```bash
python -m venv myenv
```

- This creates a folder called `myenv` that contains your project’s environment.
  
**On Windows**:  
  Open the command prompt and run the above.

**On Linux/macOS**:  
  Open your terminal and run the above.

---

# Step 2: Activating the Virtual Environment

```bash
# On Linux/macOS:
source myenv/bin/activate

# On Windows:
myenv\Scripts\activate
```

Now, your environment is **active**, and any packages you install will go inside `myenv`.

---

# Step 3: Installing Dependencies

```bash
pip install pandas numpy
```

- This installs the libraries you need, but only in the virtual environment—**not system-wide**.
- Can specify version numbers if you want. 

---

# Step 4: Freezing Dependencies

```bash
pip freeze > requirements.txt
```

This creates a `requirements.txt` file that lists all the libraries and their exact versions.

---

# Sharing Your Requirements File

- Add the `requirements.txt` file to your GitHub repository.
- Others can recreate your environment by running:

```bash
pip install -r requirements.txt
```

This ensures others will have the exact same versions of packages, preventing version mismatches.

---

# Creating a Virtual Environment in R

1. Install the `renv` package.
2. Initialize a new environment with `renv::init()`.
3. Install packages 
4. Use `renv::snapshot()` to save the versions.

```r
install.packages("renv")
renv::init()
renv::snapshot()
```

---

# Step 4 (R): Restoring an Environment with renv

To share and recreate the same environment in R, others will need to run:

```r
renv::restore()
```

This installs the exact versions of packages as listed in the `renv.lock` file.

---
# `requirements.txt` (Python) vs. `renv.lock` (R)

### `requirements.txt` (Python):
- Just list of packages and versions.

### `renv.lock` (R):
- Also includes R version, which packages are dependent on what


---

# What If We Want to Test on Different Systems?

---

# GitHub Actions: Automated Testing Across Systems

- With **GitHub Actions**, you can run tests across multiple Python or R versions on Windows, Linux, and macOS **automatically** when you push your code.

- Example: When you push code, GitHub Actions will test it in multiple environments for you.

---

# Setting Up GitHub Actions for Testing

1. Add a `.github/workflows/test.yml` file to your repo.
2. Configure it to test across different Python versions
3. Specify Python versions, operating systems
4. There are R implemenations as well

---

# What If You Want To Reproduce The Whole Computer?


For that, you can use **Docker**.

---

# Docker: What Is It?

- Docker creates **containers**—small virtual machines that contain everything your code needs to run.
- Unlike virtual environments, Docker bundles:
  - The OS
  - Libraries
  - The code itself
  - Data, if needed

---

# Docker vs. Virtual Environments: Another Difference

- A `requirements.txt` file is **instructions** for installing packages.  
- A **Dockerfile** is more like an **installer**—it builds the environment for you, including the OS, libraries, and code.

- If you're in a locked-down environment where you can't install software, a `requirements.txt` won’t help—but a Dockerfile will!

---

# Why Would You Use Docker?

Docker is useful when:
1. **Closed environment** but need specific packages or libraries.
2. **You want to run Linux** on a Windows or macOS machine.
3. **Reproducibility**: You want to guarantee your code runs the same way on any machine.
4. **Portability**: You need to ship code with all its dependencies, like sharing models or data

---


# Using Someone Else’s Dockerfile from DockerHub

You don’t have to create your own Dockerfile from scratch. You can use pre-built images from **DockerHub**.

Example:
```bash
docker pull rocker/r-ver:4.0.3
```

This pulls an R container ready to use with version 4.0.3.

---

# Writing Your Own Dockerfile: Why & How

### Why:
- You may want more control over the exact packages, configurations, and code.

### How:
- A **Dockerfile** lets you define what goes into the container.

---

# Writing a Dockerfile for Python

```Dockerfile
FROM python:3.9
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

This builds a container that installs your code and dependencies in Python.

---

# Writing a Dockerfile for R

```Dockerfile
FROM rocker/r-ver:4.0.3
WORKDIR /app
COPY . /app
RUN Rscript -e 'install.packages(c("dplyr", "ggplot2"))'
CMD ["Rscript", "script.R"]
```

This builds a container with R version 4.0.3 and the required R packages.

---

# Running a Docker Container: Non-Interactive Mode

In **non-interactive mode**, you simply run your container, and it executes the program inside.

Example:
```bash
docker run my-app
```

This runs your code inside the Docker container automatically.

---

# Running a Docker Container: Interactive Mode

In **interactive mode**, you enter the container and work within it.

Example:
```bash
docker run -it my-app /bin/bash
```

This gives you a shell inside the container, where you can explore and run commands interactively.

---

# Step-by-Step: Building & Running Your Docker Container

1. **Build the container**:
   ```bash
   docker build -t my-app .
   ```

2. **Run the container** (non-interactive):
   ```bash
   docker run my-app
   ```

3. **Run interactively**:
   ```bash
   docker run -it my-app /bin/bash
   ```

---

# Using Someone Else's Dockerfile from GitHub

You can also **clone a repo** with a `Dockerfile` and build the container directly:

```bash
git clone https://github.com/username/repo-with-dockerfile.git
cd repo-with-dockerfile
docker build -t my-app .
docker run my-app
```

This will clone the repository, build the Docker container from the Dockerfile, and run it.

---

# Recap: Docker vs. Virtual Environments

- **Virtual Environments**: Manage libraries and package dependencies within the same system.
- **Docker**: Isolates the entire system, including the OS, code, and all dependencies.

Use Docker when:
1. You need to give people software/packages/models, but they can't install things. 
2. You need to run Linux on Windows/macOS.
3. You need guaranteed reproducibility across machines.

---

# Docker Use Case: RStudio on Docker

- You can use Docker to run **RStudio** in a container, even if RStudio can’t be installed on your machine.

```bash
docker pull rocker/rstudio
docker run -e PASSWORD=mysecretpassword -p 8787:8787 rocker/rstudio
```

- This sets up an RStudio environment that you can access via a web browser on port 8787.

---

# Docker Use Case: Python Projects

- Docker is great when you need to run a **Python project** in an environment that others can't modify.

```bash
FROM python:3.9
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

- Build and run the container:
  
```bash
docker build -t python-app .
docker run python-app
```

---

# Wrap-Up: Virtual Environments & Docker

- **Virtual Environments**: Isolate your dependencies and libraries in a lightweight environment.
- **Docker**: Create full, reproducible containers with everything included.

Each has its place, depending on your needs for portability, reproducibility, and system-level consistency.

---

# Thank You!

- Questions?


---



# Appendix: Freezing Python Dependencies

```bash
pip freeze > requirements.txt
```

This will save the exact versions in a `requirements.txt` file so others can install the same versions.

---

# Appendix: Freezing R Dependencies

```r
renv::snapshot()
```

This saves the exact versions of R packages in a `renv.lock` file for reproducibility.

---

# Appendix: Pulling a Docker Image from DockerHub

```bash
docker pull python:3.9
```

This downloads the official Python 3.9 image from DockerHub.

---

# Appendix: Pulling RStudio from DockerHub

```bash
docker pull rocker/rstudio
docker run -e PASSWORD=mysecretpassword -p 8787:8787 rocker/rstudio
```

This sets up an RStudio environment accessible via a browser.

---

# Appendix: Creating and Pushing a Dockerfile to DockerHub

1. **Build your Docker image**:

```bash
docker build -t my-app .
```

2. **Tag the image** to push it to DockerHub:

```bash
docker tag my-app your-dockerhub-username/my-app
```

3. **Push the image**:

```bash
docker push your-dockerhub-username/my-app
```

Now others can pull your Docker image from DockerHub and run it.

---

# GitHub Actions: Running Python and R Tests Automatically

GitHub Actions lets you automate testing across multiple environments. Here's how to set it up:

---

### Python Example:
```yaml
name: Test Python Versions
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.7, 3.8, 3.9]
    steps:
    - uses: actions/checkout@v2
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: ${{ matrix.python-version }}
    - run: pip install -r requirements.txt
    - run: pytest
```
---

### R Example:

---

```yaml
name: Test R Versions
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        r-version: [4.0, 4.1, 4.2]
    steps:
    - uses: actions/checkout@v2
    - name: Set up R
      uses: r-lib/actions/setup-r@v2
      with:
        r-version: ${{ matrix.r-version }}
    - run: Rscript -e "renv::restore()"
    - run: Rscript test.R
```
---
This will automatically test your code on multiple versions of Python or R each time you push to GitHub.
---