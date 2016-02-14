<% js = escape_javascript(
  render(partial: 'admins/list', locals: { hosts: @hosts })
) %>
$("#filterrific_results").html("<%= js %>");