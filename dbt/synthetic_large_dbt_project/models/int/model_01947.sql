{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01463') }},
        {{ ref('model_01309') }}
)
select id, 'model_01947' as name from sources
