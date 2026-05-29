{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00603') }},
        {{ ref('model_00516') }},
        {{ ref('model_00137') }}
)
select id, 'model_00919' as name from sources
