<jsp:useBean id="task" scope="session"
    class="com.openq.pbar.TaskBean"/>

<% task.setRunning(false); %>

<jsp:forward page="status.jsp"/>
