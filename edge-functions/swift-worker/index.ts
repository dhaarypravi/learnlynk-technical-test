// supabase/functions/swift-worker/index.ts
import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const supabase = createClient(
  Deno.env.get("PROJECT_URL")!,
  Deno.env.get("SERVICE_ROLE_KEY")!
);

serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "Only POST is allowed" }), {
        status: 405,
      });
    }

    const body = await req.json();
    const { application_id, task_type, due_at } = body;

    // Task type validation
    const validTypes = ["call", "email", "review"];
    if (!validTypes.includes(task_type)) {
      return new Response(JSON.stringify({ error: "Invalid task type" }), {
        status: 400,
      });
    }

    // due_at validation
    const dueDate = new Date(due_at);
    if (isNaN(dueDate.getTime()) || dueDate <= new Date()) {
      return new Response(
        JSON.stringify({ error: "due_at must be a future datetime" }),
        { status: 400 }
      );
    }

    // Insert into tasks
    const { data, error } = await supabase
      .from("tasks")
      .insert({
        application_id,
        type: task_type,
        due_at,
        tenant_id: "00000000-0000-0000-0000-000000000000"
      })
      .select("id")
      .single();

    if (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 400,
      });
    }

    // Send realtime event
    await supabase.channel("task-created").send({
      type: "broadcast",
      event: "task.created",
      payload: { task_id: data.id },
    });

    return new Response(JSON.stringify({ success: true, task_id: data.id }), {
      status: 200,
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
    });
  }
});
