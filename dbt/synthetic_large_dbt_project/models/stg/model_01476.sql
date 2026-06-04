{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00468') }},
        {{ ref('model_00504') }}
)
select id, 'model_01476' as name from sources
