# 🌥️ Cloud Resume Challenge (Azure Edition) - chinmaydas.site

Welcome to my implementation of the **Cloud Resume Challenge**, a full-stack cloud project designed to demonstrate practical Azure skills by building and deploying a personal resume website. You can view the live site here: **[chinmaydas.site](https://chinmaydas.site)**

---

## ✅ Challenge Overview

This project follows the [Cloud Resume Challenge for Azure](https://cloudresumechallenge.dev/docs/the-challenge/azure/) and includes:

### 1. 🌐 HTML
- Resume built using semantic, accessible **HTML5**.

### 2. 🎨 CSS
- Styled with **CSS3**, with responsiveness and a clean layout in mind.

### 3. 📄 Static Website
- Deployed the website on **Azure Storage Static Website Hosting**.

### 4. 🔐 HTTPS
- Configured **Azure CDN** to enable **HTTPS**.

### 5. 🌍 DNS
- Custom domain set up via [chinmaydas.site](https://chinmaydas.site) using Azure DNS.

### 6. 📈 JavaScript
- Integrated a **visitor counter** using client-side JavaScript.

### 7. 🗄️ Database
- Visitor data stored and retrieved from **Azure CosmosDB (Table API)** using **serverless** mode.

### 8. 🧩 API
- Built a secure API using **Azure Functions (HTTP Trigger)** to interact with CosmosDB.

### 9. ⚙️ Infrastructure as Code
- Deployed all infrastructure (Functions, CosmosDB, Storage, CDN, DNS) using **Terraform**.

### 10. 💾 Source Control
- Managed code with Git, hosted in **GitHub** with two repositories:
  - `frontend`: Website (HTML/CSS/JS)
  - `backend`: Azure Functions, IaC, and tests

### 11. 🔁 CI/CD (Backend)
- Set up **GitHub Actions** to:
  - Deploy Azure Functions and Terraform automatically on push

### 12. 🚀 CI/CD (Frontend)
- GitHub Actions for automatic deployment of the static site to Azure Storage.
- CDN endpoint purged on new deployments.
---

## 💡 Tech Stack

- **Frontend**: HTML5, CSS3, JavaScript
- **Backend**: Azure Functions, CosmosDB Table API
- **DevOps**: GitHub Actions, Terraform
- **Hosting**: Azure Static Website, Azure CDN, Azure DNS

---

## 🚧 Future Improvements

- Add dark mode toggle
- Integrate analytics
- Implement caching on API responses
- Add versioning to resume updates

---

## 📬 Contact

If you'd like to connect or collaborate, feel free to reach out via [chinmaydas.site](https://chinmaydas.site) or LinkedIn.

---

## 📄 License

MIT License. See [`LICENSE`](./LICENSE) for details.

