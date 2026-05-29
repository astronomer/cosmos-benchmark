{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00871') }},
        {{ ref('model_01313') }}
)
select id, 'model_02018' as name from sources
