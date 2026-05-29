{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00367') }},
        {{ ref('model_00192') }}
)
select id, 'model_00881' as name from sources
