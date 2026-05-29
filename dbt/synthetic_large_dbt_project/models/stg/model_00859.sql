{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00383') }},
        {{ ref('model_00574') }},
        {{ ref('model_00662') }}
)
select id, 'model_00859' as name from sources
