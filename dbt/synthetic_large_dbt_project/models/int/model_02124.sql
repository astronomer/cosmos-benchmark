{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00993') }},
        {{ ref('model_00885') }}
)
select id, 'model_02124' as name from sources
