# Resume Scanner Frontend

A modern Flutter web app for uploading resumes and receiving smart keyword analysis based on job descriptions or custom keywords. Connected to a FastAPI backend that performs natural language processing to score resumes and provide improvement suggestions.


## Features

- Upload resumes in PDF format
- Add job descriptions and/or custom keyword lists
- Customize keyword weightings
- View resume score and skill breakdown
- See matched and missing skills by category
- Get improvement suggestions

## Screenshots

maybe coming soon...

## How it Works

1. Users upload a resume
2. They may also add a job description, keywords, or custom weightings
3. The app sends data to the FastAPI backend
4. Backend parses the resume and analyzes keyword matches
5. Results are displayed as scores, breakdowns, and suggestions

## Form Data (Frontend → Backend)

| Field             | Type   | Required | Description |
|------------------|--------|----------|-------------|
| `file`           | File   | ✅       | Resume in PDF format |
| `description`    | String | ⚠️       | Job description text (required if `keywords` is not given) |
| `keywords`       | File   | ⚠️       | JSON file with keyword categories (required if `description` is not given) |
| `weights`        | File   | ❌       | JSON file with custom weights per category (optional) |

**Note:** You can leave every text field empty now, the backend will use default templates

## Local Setup

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK
- A modern browser (for web preview)

### Run Locally

```bash
# Clone the repo
git clone https://github.com/Liam-Samsit/resume-scanner-frontend.git
cd resume-scanner-frontend

# Get packages
flutter pub get

# Run the app
flutter run -d chrome
````

## Tech Stack

* **Frontend:** Flutter (Web)
* **Backend:** FastAPI (Python)

## Backend Repo Link

* [resume-scanner-backend](https://github.com/Liam-Samsit/resume-scanner-backend.git)

## Author

**Khaled Sami Cheboui**
GitHub: [Liam-Samsit](https://github.com/Liam-Samsit)

---

## License

This project is licensed under the [MIT License](LICENSE).
