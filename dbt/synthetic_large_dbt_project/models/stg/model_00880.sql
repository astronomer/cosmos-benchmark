{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00610') }},
        {{ ref('model_00536') }},
        {{ ref('model_00345') }}
)
select id, 'model_00880' as name from sources
