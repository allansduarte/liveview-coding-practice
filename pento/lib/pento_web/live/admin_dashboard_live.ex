defmodule PentoWeb.AdminDashboardLive do
  use PentoWeb, :live_view

  @survey_topic "survey_results"
  @user_activity_topic "user_activity"

  def mount(_params, _session, socket) do
    connected?(socket) && do_subscribe()

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")
     |> assign(:user_activity_component_id, "user-activity")}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(
      UserActivityLive,
      id: socket.assigns.user_activity_component_id
    )

    {:noreply, socket}
  end

  defp do_subscribe do
    Endpoint.subscribe(@survey_topic)
    Endpoint.subscribe(@user_activity_topic)
  end
end
