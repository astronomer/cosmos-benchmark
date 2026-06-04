{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02021') }}
)
select id, 'model_02779' as name from sources
