import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

#Intro section for manage reviews page
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_rev_card"):
    ui.element("h2", children=["Manage Past Reviews"], className="text-2xl font-bold text-gray-800", key="view_rev_title")
    ui.element("div", children=["\n\n"], key="view_rev_divider")
    ui.element("p", children=["View, update, and delete your previous reviews."], className="text-gray-600")

#Retrieves information on each student
data = {} 
try:
    data = requests.get('http://api:4000/r/reviews/student/1').json()
    ui.element("h3", children=["Reviews"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = []  

#Removes review from the database  
def deleteReview(review_id):
    try:
        response = requests.delete(f'http://api:4000/r/reviews/{review_id}')
        if response.status_code == 200:
            logger.info(f"Review deleted: {review_id}")
            ui.alert_dialog(
            show=True, 
            title="Deleted review", 
            description=f"The review under the ID:{review_id} has been deleted.", 
            confirm_label="OK", 
            cancel_label="Cancel", 
            key=f"delete_dialog_{review_id}"
            )
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to delete review: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"delete_review_error_{review_id}"
            )
    except Exception as e:
        logger.error(f"Error deleting review {review_id}: {str(e)}")
        ui.element(
            "p",
            children=["Failed to delete review: Unknown error"],
            className="text-red-500",
            key=f"delete_review_error_{review_id}"
        )

#Displays studnet information and provides update and delete buttons
def StudentProfileCard(review):
    with ui.element("div", key=f"review_card_{review['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element(
            "h3",
            children=[f"Rating: {review['rating']} / 5"],
            className="text-xl font-bold text-gray-800",
            key=f"review_rating_{review['id']}"
        )
        
        ui.element(
            "p",
            children=[review['review']],
            className="text-gray-600",
            key=f"review_text_{review['id']}"
        )

        ui.element("p", children=[f"Written by: {review['student_name']}"], className="text-gray-600", key=f"review_student_{review['id']}")

    col1, col2, col3, col4, col5, col6, col7, col8 = st.columns(8)

    with col1:
        #Takes user to update student profile page
        updateBtn = ui.button("Update", className="bg-purple-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"update_review_{review['id']}")
        if updateBtn:
            st.session_state['updating_review_id'] = review['id']
            st.switch_page('pages/Update_Review.py')


    with col2:
        #Deletes student from database
        deleteBtn = ui.button("Delete", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"delete_student_{student['id']}")
        if deleteBtn:
            deleteStudent(student['id'], student['name'])
           

#If there are students in the database, display their information
if data and isinstance(data, list):
    if data:
        for student in data:
            StudentProfileCard(student)
    else:
        ui.element("h3", children=["No students found."], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No students found."], className="text-xl font-bold text-gray-800")
