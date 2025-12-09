from locust import HttpUser, task,  between

class User(HttpUser):
    wait_time = between(1, 3)
    host = "http://localhost:5080"
    
    #Authentication
    def on_start(self):
        self.client.get("/openmeetings/signin")
        login_data = {
            "credentials:login": "om_admin",
            "credentials:pass": "1Q2w3e4r5t^y",
            "p::submit": "1"
        }

        self.client.post(
            "/openmeetings/wicket/bookmarkable/org.apache.openmeetings.web.pages.auth.SignInPage",
            data=login_data,
            allow_redirects=True,
        )
        self.client.get("/openmeetings/")

    @task
    def dashboard(self):
        self.client.get("/openmeetings/")
