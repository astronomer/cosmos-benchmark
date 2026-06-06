{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00535') }},
        {{ ref('model_00469') }},
        {{ ref('model_00694') }}
)
select id, 'model_01282' as name from sources
