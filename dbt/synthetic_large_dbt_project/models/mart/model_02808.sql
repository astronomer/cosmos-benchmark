{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02107') }},
        {{ ref('model_01798') }}
)
select id, 'model_02808' as name from sources
