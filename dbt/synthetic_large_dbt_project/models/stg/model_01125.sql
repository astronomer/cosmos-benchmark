{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00173') }},
        {{ ref('model_00358') }}
)
select id, 'model_01125' as name from sources
