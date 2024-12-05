# Idea borrowed from https://github.com/fsmosca/sample-streamlit-authenticator

# This file has function to add certain functionality to the left side bar of the app

import streamlit as st


#### ------------------------ General ------------------------
def HomeNav():
    st.sidebar.page_link("Opening_Screen.py", label="Home", icon="🏠")

def UserSelection():
    st.sidebar.page_link("pages/User_Selection_Page.py", label="User Selection", icon="👤")

def AboutPageNav():
    st.sidebar.page_link("pages/About_Page.py", label="About", icon="🧠")


# ------------------------ Maura Tabs (CS Sophomore) ------------------------
def ViewJobs():
    st.sidebar.page_link("pages/View_Jobs.py", label="View Jobs", icon="👀")

def SeePredecessors():
    st.sidebar.page_link("pages/See_Predecessors.py", label="See Predecessors", icon="📖")

def ResearchInterviewQuestions():
    st.sidebar.page_link("pages/Research_Interview_Questions.py", label="Study Interview Questions", icon="🔍")

def SeeReviews():
    st.sidebar.page_link("pages/See_Reviews.py", label="See Reviews", icon="📝")

def ApplicationStatuses():
    st.sidebar.page_link("pages/Application_Statuses.py", label="Application Statuses", icon="📊")

def ApplyJobs():
    st.sidebar.page_link("pages/Apply_Jobs.py", label="Submit Applications", icon="📤")


## ------------------------ Wade Tabs (DS Senior) ------------------------

def PostReview():
    st.sidebar.page_link("pages/Post_Review.py", label="Post Review", icon="📝")
    
def PostInterviewQuestions():
    st.sidebar.page_link("pages/Post_Interview_Question.py", label="Post Interview Questions", icon="🔍")
    
def ViewReviewsAsSenior():
    st.sidebar.page_link("pages/See_Reviews.py", label="See Reviews", icon="📝")
    
def ViewJobsAsSenior():
    st.sidebar.page_link("pages/View_Jobs.py", label="View Jobs", icon="👀")

## questions from peers?

## ------------------------ Damian Tabs (Recruiter) ------------------------

def ManageJobPostings():
    st.sidebar.page_link("pages/Manage_Job_Postings.py", label="Manage Job Postings", icon="📝")

def SearchStudents():
    st.sidebar.page_link("pages/Search_Students.py", label="Search Students", icon="🔍")

def ViewSimilarJobs():
    st.sidebar.page_link("pages/View_Similar_Jobs.py", label="View Similar Job Postings", icon="👀")

def ViewReviewsAsRecruiter():
    st.sidebar.page_link("pages/See_Reviews.py", label="See Reviews", icon="👀")

def ManageJobApps():
    st.sidebar.page_link("pages/Manage_Job_Applications.py", label="Manage Job Applications", icon="📊")
    
## ------------------------ Winston Tabs (Co-op Advisor) ------------------------

def ViewRecruiters():
    st.sidebar.page_link("pages/View_Recruiters.py", label="View Recruiters", icon="👀")

def ViewJobsAsAdvisor():
    st.sidebar.page_link("pages/View_Jobs.py", label="View Jobs", icon="👀")
    
def ViewReviewsAsAdvisor():
    st.sidebar.page_link("pages/See_Reviews.py", label="See Reviews", icon="📝")
    
def ManageStudents():
    st.sidebar.page_link("pages/Student_Profiles.py", label="Manage Students", icon="👥")

# --------------------------------Links Function -----------------------------------------------
def SideBarLinks(show_home=False):
    """
    This function handles adding links to the sidebar of the app based upon the logged-in user's role, which was put in the streamlit session_state object when logging in.
    """

    # add a logo to the sidebar always
    st.sidebar.image("assets/husky.png", width=150)

    # If there is no logged in user, redirect to the Home (Landing) page
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Opening_Screen.py")

    if show_home:
        # Show the Home page link (the landing page)
        HomeNav()

    # Show the other page navigators depending on the users' role.
    if st.session_state["authenticated"]:

        # Pages available to Maura Turner
        if st.session_state["role"] == "sophomore":
            ViewJobs()
            SeePredecessors()
            ResearchInterviewQuestions()
            SeeReviews()
            ApplicationStatuses()
            ApplyJobs()

        # If the user role is usaid worker, show the Api Testing page
        if st.session_state["role"] == "senior":
            ViewJobsAsSenior()
            PostReview()
            PostInterviewQuestions()
            ViewReviewsAsSenior()

        # If the user is an administrator, give them access to the administrator pages
        if st.session_state["role"] == "recruiter":
            ManageJobPostings()
            SearchStudents()
            ViewSimilarJobs()
            ViewReviewsAsRecruiter()
            ManageJobApps()
            
        if st.session_state["role"] == "advisor":
            ViewRecruiters()
            ViewJobsAsAdvisor()
            ViewReviewsAsAdvisor()
            ManageStudents()

    # Always show the About page at the bottom of the list of links
    AboutPageNav()

    if st.session_state["authenticated"]:
        # Always show a logout button if there is a logged in user
        if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("pages/User_Selection_Page.py")
