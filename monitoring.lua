
local current_epics_metric = monitoring.gauge("epic_current_running", "count of currently running epics")
local current_epics = 0

local executed_epics = monitoring.counter("epic_executed_epics", "count of executed epics")
local executed_blocks = monitoring.counter("epic_executed_blocks", "count of executed blocks")

local time_budget = monitoring.counter("epic_time_budget", "count of microseconds used in cpu time")

local exited_normally = monitoring.counter("epic_exited", "count of normally exited epics")
local exited_abort = monitoring.counter("epic_aborted", "count of aborted epics")

epic.register_hook({
  on_execute_function = function()
    executed_epics.inc()
    current_epics = current_epics + 1
    current_epics_metric.set(current_epics)
  end,

  on_before_node_enter = function()
    executed_blocks.inc()
  end,

  on_epic_exit = function()
    exited_normally.inc()
    current_epics = current_epics - 1
    current_epics_metric.set(current_epics)
  end,

  on_epic_abort = function()
    exited_abort.inc()
    current_epics = current_epics - 1
    current_epics_metric.set(current_epics)
  end,

  globalstep_stats = function(stats)
    time_budget.inc(stats.time)
  end
})
