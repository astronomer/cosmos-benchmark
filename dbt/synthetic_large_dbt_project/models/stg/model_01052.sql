{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00601') }},
        {{ ref('model_00533') }}
)
select id, 'model_01052' as name from sources
