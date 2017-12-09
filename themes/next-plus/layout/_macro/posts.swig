{% macro render(posts) %}
  <ul>
  {% for post in posts %}
    <li>
      <a style="font-size: 16px" href="{{ url_for(post.path) }}">
        {{ post.title | default(__('post.untitled'))}}
      </a>
      <span style="margin-left: 8px; color: #9c9c9c">
        {{ date(post.date, config.month_format) }}
      </span>
    </li>
  {% endfor %}
  </ul>