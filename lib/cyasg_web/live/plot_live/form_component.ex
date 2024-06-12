defmodule CyasgWeb.PlotLive.FormComponent do
  use CyasgWeb, :live_component

  alias Cyasg.Datasets
  alias Cyasg.Plots

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage plot records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="plot-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:dataset]} type="select" label="Dataset" options={@datasets} />
        <p>
          <%= "'#{Enum.join(@columns, "','")}'" %>
        </p>
        <.input field={@form[:expression]} type="text" label="Expression" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Plot</.button>
        </:actions>
      </.simple_form>

      <div :if={not @changeset.valid?} class="flex justify-center items-center">
        <.spinner />
      </div>

      <div
        :if={@changeset.valid?}
        id="plot"
        phx-update="ignore"
        phx-hook="Plotly"
        data-plotly={
          Jason.encode!([
            %{
              "x" => Enum.into(@datapoints, []),
              "type" => "histogram"
            }
          ])
        }
      >
      </div>
    </div>
    """
  end

  @impl true
  def update(%{plot: plot} = assigns, socket) do
    changeset = Plots.change_plot(plot)

    {:ok,
     socket
     |> assign(:datasets, Datasets.list())
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"plot" => plot_params}, socket) do
    changeset =
      socket.assigns.plot
      |> Plots.change_plot(plot_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"plot" => plot_params}, socket) do
    save_plot(socket, socket.assigns.action, plot_params)
  end

  defp save_plot(socket, :edit, plot_params) do
    user_id = socket.assigns.current_user.id

    case Plots.update_user_plot(
           user_id,
           socket.assigns.plot,
           socket.assigns.datapoints,
           plot_params
         ) do
      {:ok, plot} ->
        # TODO: use user specific topic, also send to sharings
        CyasgWeb.Endpoint.broadcast("plots-#{user_id}", "saved", plot)

        Enum.each(plot.sharings, fn s ->
          CyasgWeb.Endpoint.broadcast("sharing-#{s.user_id}", "saved", plot)
        end)

        {:noreply,
         socket
         |> put_flash(:info, "Plot updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_plot(socket, :new, plot_params) do
    user_id = socket.assigns.current_user.id

    case Plots.create_user_plot(user_id, socket.assigns.datapoints, plot_params) do
      {:ok, plot} ->
        CyasgWeb.Endpoint.broadcast("plots-#{user_id}", "saved", plot)

        {:noreply,
         socket
         |> put_flash(:info, "Plot created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    datasets = socket.assigns.datasets

    dataset = Ecto.Changeset.get_field(changeset, :dataset) || List.first(datasets)
    expression = Ecto.Changeset.get_field(changeset, :expression)

    datapoints =
      cond do
        not changeset.valid? -> []
        Map.get(socket.assigns, :dataset) != dataset -> Datasets.column(dataset, expression)
        Map.get(socket.assigns, :expression) != expression -> Datasets.column(dataset, expression)
        true -> []
      end

    socket
    |> assign(:form, to_form(changeset))
    |> assign(:dataset, dataset)
    |> assign(:expression, expression)
    |> assign(:changeset, changeset)
    |> assign(:columns, Ecto.Changeset.get_field(changeset, :columns))
    |> assign(:datapoints, datapoints)
  end
end
