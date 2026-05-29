{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01038') }},
        {{ ref('model_00796') }},
        {{ ref('model_00915') }}
)
select id, 'model_01584' as name from sources
