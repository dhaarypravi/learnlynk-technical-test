"use client";

import { useQuery, useMutation } from "@tanstack/react-query";
import { supabase } from "@/lib/supabaseClient";

export default function TodayTasks() {
  const fetchTasks = async () => {
    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);

    const todayEnd = new Date();
    todayEnd.setHours(23, 59, 59, 999);

    const { data, error } = await supabase
      .from("tasks")
      .select("*")
      .gte("due_at", todayStart.toISOString())
      .lte("due_at", todayEnd.toISOString());

    if (error) throw error;
    return data;
  };

  const { data, isLoading, isError, error, refetch } = useQuery({
    queryKey: ["todayTasks"],
    queryFn: fetchTasks,
  });

  const mutation = useMutation({
    mutationFn: async (taskId) => {
      const { error } = await supabase
        .from("tasks")
        .update({ status: "completed" })
        .eq("id", taskId);

      if (error) throw error;
    },
    onSuccess: () => refetch(),
  });

  if (isLoading) return <p>Loading...</p>;
  if (isError) return <p>Error: {error.message}</p>;

  return (
    <div style={{ padding: 20 }}>
      <h1>Tasks Due Today</h1>

      {data?.length === 0 && <p>--No tasks due today--</p>}

      <table border="1" cellPadding="10">
        <thead>
          <tr>
            <th>Title</th>
            <th>Application ID</th>
            <th>Due At</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>

        <tbody>
          {data?.map((task) => (
            <tr key={task.id}>
              <td>{task.title ?? "(untitled)"}</td>
              <td>{task.application_id}</td>
              <td>{new Date(task.due_at).toLocaleString()}</td>
              <td>{task.status}</td>
              <td>
                <button
                  disabled={task.status === "completed"}
                  onClick={() => mutation.mutate(task.id)}
                >
                  Mark Complete
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
