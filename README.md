# Credit Minder App

Credit Minder is a Flutter application designed to help users manage their credits and debts. The app allows users to add, view, and manage their financial records. It supports user authentication and provides a seamless experience across web and Android platforms.

## Project Preview

<table>
  <tr>
    <td><img src="/preview/mobile_preview_1.jpg" alt="Credit Minder App Screenshot" width="300" height="600"></td>
    <td><img src="/preview/mobile_preview_2.jpg" alt="Credit Minder App Screenshot" width="300" height="600"></td>
    <td><img src="/preview/mobile_preview_3.jpg" alt="Credit Minder App Screenshot" width="300" height="600"></td>
  </tr>
    <tr>
    <td colspan="3"><img src="/preview/web_preview_1.png" alt="Credit Minder App Screenshot" width="800" height="400"></td>
  </tr>
  <tr>
    <td colspan="3"><img src="/preview/web_preview_2.png" alt="Credit Minder App Screenshot" width="800" height="400"></td>
  </tr>
  <tr>

</table>

## Hosted Web App

The Credit Minder web app is hosted on Vultr server instance. You can access it at the following link:

[Credit Minder Web App](http://139.84.169.208)

## Checkout server Repo

You can find the server repository at the following link:

[Credit Minder Server Repository](https://github.com/varunthapa777/CreditMinderServer)

## Features

- User Authentication (Login and Registration)
- Add, View, and Manage Financial Records
- Search Functionality
- Responsive Design for Web and Mobile
- Persistent Login using SharedPreferences

## Use of Vultr Cloud Service

The Credit Minder app leverages Vultr cloud services to host both its web application and database. Vultr provides a reliable and scalable infrastructure that ensures the web app and database are always available and perform optimally. Here are some key benefits of using Vultr for our app:

- **Scalability**: Easily scale the server resources up or down based on the app's demand.
- **Performance**: High-performance SSD storage and fast network connectivity ensure quick load times and a smooth user experience.
- **Reliability**: Vultr's robust infrastructure ensures high availability and minimal downtime.
- **Security**: Built-in security features help protect the app and user data from potential threats.

By hosting the Credit Minder web app and database on Vultr, we ensure that our users have a seamless and reliable experience when managing their financial records online.

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Node.js and npm: [Install Node.js](https://nodejs.org/)
- MySQL: [Install MySQL](https://dev.mysql.com/downloads/)

### Backend Setup

1. Clone the repository:

   ```sh
   git clone https://github.com/your-username/credit-minder.git
   cd credit-minder/backend
   ```

2. Install dependencies:

   ```sh
   npm install
   ```

3. Set up the MySQL database:

   ```sh
   mysql -u root -p
   CREATE DATABASE credit_minder;
   ```

4. Configure environment variables:

   Create a `.env` file in the `backend` directory and add the following:

   ```env
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=yourpassword
   DB_NAME=credit_minder
   ```

5. Run database migrations:

   ```sh
   npx sequelize-cli db:migrate
   ```

6. Start the backend server:

   ```sh
   npm start
   ```

### Frontend Setup

1. Navigate to the frontend directory:

   ```sh
   cd ../frontend
   ```

2. Install Flutter dependencies:

   ```sh
   flutter pub get
   ```

3. Run the Flutter app:

   ```sh
   flutter run
   ```

### Deployment

#### Backend Deployment

1. Set up a server (e.g., AWS EC2, DigitalOcean Droplet).
2. Install Node.js and MySQL on the server.
3. Clone the repository on the server:

   ```sh
   git clone https://github.com/your-username/credit-minder.git
   cd credit-minder/backend
   ```

4. Install dependencies:

   ```sh
   npm install
   ```

5. Set up the MySQL database on the server and configure environment variables as described in the Backend Setup section.

6. Run database migrations:

   ```sh
   npx sequelize-cli db:migrate
   ```

7. Start the backend server using a process manager like PM2:

   ```sh
   npm install -g pm2
   pm2 start npm --name "credit-minder-backend" -- start
   ```

#### Frontend Deployment

1. Build the Flutter web app:

   ```sh
   flutter build web
   ```

2. Serve the web app using a web server (e.g., Nginx, Apache).

3. Configure the web server to serve the files from the `build/web` directory.

Example Nginx configuration:

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        root /path/to/credit-minder/frontend/build/web;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
}
```

4. Restart the web server to apply the changes.

Now your Credit Minder app should be fully deployed and accessible via your domain.
