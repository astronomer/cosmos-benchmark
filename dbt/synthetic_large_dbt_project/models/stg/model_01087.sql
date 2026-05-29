{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00040') }},
        {{ ref('model_00496') }}
)
select id, 'model_01087' as name from sources
