{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00693') }},
        {{ ref('model_00533') }}
)
select id, 'model_00858' as name from sources
