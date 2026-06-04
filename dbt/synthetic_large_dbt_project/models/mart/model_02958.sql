{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01744') }},
        {{ ref('model_01709') }}
)
select id, 'model_02958' as name from sources
