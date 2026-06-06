{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01706') }},
        {{ ref('model_01716') }},
        {{ ref('model_01651') }}
)
select id, 'model_02826' as name from sources
